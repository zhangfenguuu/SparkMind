//
//  AudioPlayer.swift
//  SparkMind
//
//  Created by 张峰 on 2025/9/23.
//

import Foundation
import AVFoundation
import Combine

final class AudioPlayer: ObservableObject {
    @Published private(set) var isPlaying = false
    @Published private(set) var currentURL: URL?

    private var player: AVPlayer?
    private var timeObserver: Any?
    private var cancellables = Set<AnyCancellable>()

    func play(url: URL) {
        if currentURL == url, isPlaying {
            pause()
            return
        }

        stop()

        currentURL = url
        let item = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: item)
        player?.play()
        isPlaying = true

        // observe end
        NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime, object: item)
            .sink { [weak self] _ in
                self?.isPlaying = false
            }
            .store(in: &cancellables)
    }

    func pause() {
        player?.pause()
        isPlaying = false
    }

    func stop() {
        player?.pause()
        player = nil
        isPlaying = false
        currentURL = nil
        cancellables.removeAll()
    }
}
