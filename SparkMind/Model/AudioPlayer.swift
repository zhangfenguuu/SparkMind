//
//  AudioPlayer.swift
//  SparkMind
//
//  Created by 张峰 on 2025/9/23.
//

import Foundation
import AVFoundation
import Combine
// swift

final class AudioPlayer: ObservableObject {
    @Published private(set) var isPlaying = false
    @Published private(set) var currentURL: URL?
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0

    private var player: AVPlayer?
    private var timeObserverToken: Any?
    private var statusObserver: NSKeyValueObservation?
    private var cancellables = Set<AnyCancellable>()

    deinit { cleanup() }

    func play(url: URL) {
        if currentURL != url {
            cleanup()
            currentURL = url
            let item = AVPlayerItem(url: url)
            player = AVPlayer(playerItem: item)

            // Observe duration when ready
            statusObserver = item.observe(\.status, options: [.initial, .new]) { [weak self] item, _ in
                guard let self = self else { return }
                if item.status == .readyToPlay {
                    self.duration = item.duration.isIndefinite ? 0 : CMTimeGetSeconds(item.duration)
                }
            }

            // periodic time observer
            let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
            timeObserverToken = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
                guard let self = self else { return }
                self.currentTime = CMTimeGetSeconds(time)
            }
        }
        player?.play()
        isPlaying = true
    }

    func pause() {
        player?.pause()
        isPlaying = false
    }

    func stop() {
        player?.pause()
        seek(to: 0)
        isPlaying = false
        cleanup()
        currentURL = nil
    }

    func seek(to seconds: TimeInterval) {
        guard let player = player else { return }
        let time = CMTime(seconds: seconds, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player.seek(to: time)
        currentTime = seconds
    }

    private func cleanup() {
        if let token = timeObserverToken {
            player?.removeTimeObserver(token)
            timeObserverToken = nil
        }
        statusObserver?.invalidate()
        statusObserver = nil
        player = nil
    }

    // Helper: formatted time like "1:23" or "0:00"
    static func formatTime(_ seconds: TimeInterval) -> String {
        guard !seconds.isNaN && !seconds.isInfinite else { return "0:00" }
        let s = Int(round(seconds))
        let minutes = s / 60
        let secs = s % 60
        return String(format: "%d:%02d", minutes, secs)
    }
}
