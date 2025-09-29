//
//  AudioPlayer.swift
//  SparkMind
//
//  Created by 张峰 on 2025/9/23.
//
// Swift
// File: `SparkMind/Model/AudioPlayer.swift`
// swift
// File: `SparkMind/Model/AudioPlayer.swift`

import Foundation
import AVFoundation
import MediaPlayer
import Combine
import UIKit

final class AudioPlayer: ObservableObject {
    static let shared = AudioPlayer()

    @Published private(set) var isPlaying: Bool = false
    @Published private(set) var currentTime: Double = 0
    @Published private(set) var duration: Double = 0
    @Published private(set) var currentURL: URL?

    private var player: AVPlayer?
    private var timeObserverToken: Any?
    private var itemStatusObserver: NSKeyValueObservation?
    private var cancellables = Set<AnyCancellable>()
    private var remoteCommandSetupDone = false

    private init() {
        // Do lightweight configuration early: do not activate session here.
        configureAudioSessionOnce()
        setupRemoteCommands()
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption(_:)), name: AVAudioSession.interruptionNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(itemDidEnd(_:)), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleRouteChange(_:)), name: AVAudioSession.routeChangeNotification, object: nil)

        if let modes = Bundle.main.object(forInfoDictionaryKey: "UIBackgroundModes") as? [String],
           !modes.contains("audio") {
            print("Warning: Background Mode 'audio' not enabled. Enable it in Xcode Capabilities for lock-screen playback.")
        } else if Bundle.main.object(forInfoDictionaryKey: "UIBackgroundModes") == nil {
            print("Warning: UIBackgroundModes not found in Info.plist. Enable Background Modes -> Audio in Capabilities.")
        }
    }

    // MARK: - Public API

    func play(url: URL) {
        if currentURL == url && isPlaying { return }

        // ensure session category + activation immediately before playback
        guard prepareAudioSessionForPlayback() else {
            print("AudioPlayer: failed to prepare audio session for playback")
            return
        }

        let item = AVPlayerItem(url: url)
        item.canUseNetworkResourcesForLiveStreamingWhilePaused = true
        replaceCurrentItem(with: item)
        currentURL = url

        player?.automaticallyWaitsToMinimizeStalling = false
        player?.play()
        isPlaying = true
        updateNowPlayingInfo()
        print("AudioPlayer: play \(url.absoluteString)")
    }

    func pause() {
        player?.pause()
        isPlaying = false
        updateNowPlayingInfo(playbackRate: 0)
        print("AudioPlayer: pause")
    }

    func stop() {
        player?.pause()
        seek(to: 0)
        isPlaying = false
        currentURL = nil
        removePeriodicTimeObserver()
        updateNowPlayingInfo(clear: true)

        do {
            try AVAudioSession.sharedInstance().setActive(false, options: [.notifyOthersOnDeactivation])
            print("AudioPlayer: session deactivated")
        } catch {
            print("AudioPlayer: setActive(false) error: \(error)")
        }

        #if canImport(UIKit) && !targetEnvironment(macCatalyst)
        DispatchQueue.main.async { UIApplication.shared.endReceivingRemoteControlEvents() }
        #endif

        print("AudioPlayer: stop")
    }

    func seek(to seconds: Double) {
        guard let player = player else { return }
        let time = CMTime(seconds: seconds, preferredTimescale: 600)
        player.seek(to: time) { [weak self] _ in
            self?.currentTime = seconds
            self?.updateNowPlayingInfo()
        }
    }

    static func formatTime(_ seconds: Double) -> String {
        guard seconds.isFinite && seconds >= 0 else { return "--:--" }
        let intSec = Int(seconds)
        let m = intSec / 60
        let s = intSec % 60
        return String(format: "%02d:%02d", m, s)
    }

    // MARK: - Audio Session Helpers

    private func configureAudioSessionOnce() {
        // Try to set category early but avoid activation here.
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback, mode: .default, options: [])
            print("AudioSession: category set to .playback (no options)")
        } catch {
            print("AudioSession: setCategory failed: \(error). Will retry at play() time.")
        }
    }

    private func prepareAudioSessionForPlayback() -> Bool {
        let session = AVAudioSession.sharedInstance()
        // Ensure category is set (retry), then activate session.
        do {
            try session.setCategory(.playback, mode: .default, options: [])
        } catch {
            // try without options once more
            do {
                try session.setCategory(.playback, mode: .default)
            } catch {
                print("AudioSession: setCategory retry failed: \(error)")
                return false
            }
        }

        do {
            try session.setActive(true)
            #if canImport(UIKit) && !targetEnvironment(macCatalyst)
            DispatchQueue.main.async { UIApplication.shared.beginReceivingRemoteControlEvents() }
            #endif
            print("AudioSession: activated for playback")
            return true
        } catch {
            print("AudioSession: setActive(true) error: \(error)")
            return false
        }
    }

    // MARK: - Player item management

    private func replaceCurrentItem(with item: AVPlayerItem) {
        removePeriodicTimeObserver()
        itemStatusObserver = nil

        if player == nil {
            player = AVPlayer(playerItem: item)
            player?.usesExternalPlaybackWhileExternalScreenIsActive = false
        } else {
            player?.replaceCurrentItem(with: item)
        }

        itemStatusObserver = item.observe(\.status, options: [.initial, .new]) { [weak self] itm, _ in
            DispatchQueue.main.async {
                if itm.status == .readyToPlay {
                    let durSeconds = itm.duration.seconds.isFinite ? itm.duration.seconds : 0
                    self?.duration = durSeconds
                    self?.updateNowPlayingInfo()
                    self?.addPeriodicTimeObserver()
                    print("PlayerItem ready, duration:", durSeconds)
                } else if itm.status == .failed {
                    self?.duration = 0
                    print("PlayerItem failed:", itm.error as Any)
                }
            }
        }
    }

    private func addPeriodicTimeObserver() {
        guard let player = player else { return }
        removePeriodicTimeObserver()
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self = self else { return }
            self.currentTime = time.seconds
            if let currentItem = player.currentItem {
                self.duration = currentItem.duration.seconds.isFinite ? currentItem.duration.seconds : self.duration
            }
            self.updateNowPlayingInfo()
        }
    }

    private func removePeriodicTimeObserver() {
        if let token = timeObserverToken {
            player?.removeTimeObserver(token)
            timeObserverToken = nil
        }
    }

    // MARK: - Now Playing / Remote Commands

    private func updateNowPlayingInfo(playbackRate: Float? = nil, clear: Bool = false) {
        if clear {
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
            return
        }
        var info = MPNowPlayingInfoCenter.default().nowPlayingInfo ?? [String: Any]()
        if let url = currentURL {
            info[MPMediaItemPropertyTitle] = url.lastPathComponent
        }
        info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentTime
        info[MPMediaItemPropertyPlaybackDuration] = duration
        info[MPNowPlayingInfoPropertyPlaybackRate] = playbackRate ?? (isPlaying ? 1.0 : 0.0)
        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
    }

    private func setupRemoteCommands() {
        guard !remoteCommandSetupDone else { return }
        remoteCommandSetupDone = true

        let rc = MPRemoteCommandCenter.shared()

        rc.playCommand.isEnabled = true
        rc.pauseCommand.isEnabled = true
        rc.stopCommand.isEnabled = true
        rc.togglePlayPauseCommand.isEnabled = true
        rc.changePlaybackPositionCommand.isEnabled = true

        rc.playCommand.addTarget { [weak self] _ in
            guard let self = self, let url = self.currentURL else { return .commandFailed }
            self.play(url: url)
            return .success
        }

        rc.pauseCommand.addTarget { [weak self] _ in
            self?.pause()
            return .success
        }

        rc.stopCommand.addTarget { [weak self] _ in
            self?.stop()
            return .success
        }

        rc.togglePlayPauseCommand.addTarget { [weak self] _ in
            guard let self = self else { return .commandFailed }
            if self.isPlaying { self.pause() } else if let url = self.currentURL { self.play(url: url) }
            return .success
        }

        rc.changePlaybackPositionCommand.addTarget { [weak self] event in
            guard let self = self, let e = event as? MPChangePlaybackPositionCommandEvent else { return .commandFailed }
            self.seek(to: e.positionTime)
            return .success
        }
    }

    // MARK: - Notifications

    @objc private func handleInterruption(_ notification: Notification) {
        guard let info = notification.userInfo,
              let typeValue = info[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else { return }

        if type == .began {
            if isPlaying { pause() }
        } else if type == .ended {
            if let optionsValue = info[AVAudioSessionInterruptionOptionKey] as? UInt {
                let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
                if options.contains(.shouldResume), let url = currentURL {
                    play(url: url)
                }
            }
        }
    }

    @objc private func handleRouteChange(_ notification: Notification) {
        guard let info = notification.userInfo,
              let reasonValue = info[AVAudioSessionRouteChangeReasonKey] as? UInt,
              let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue) else { return }

        if reason == .oldDeviceUnavailable {
            if isPlaying { pause() }
        }
    }

    @objc private func itemDidEnd(_ note: Notification) {
        isPlaying = false
        currentTime = duration
        updateNowPlayingInfo(playbackRate: 0)
    }

    deinit {
        removePeriodicTimeObserver()
        NotificationCenter.default.removeObserver(self)
        itemStatusObserver = nil
    }
}
