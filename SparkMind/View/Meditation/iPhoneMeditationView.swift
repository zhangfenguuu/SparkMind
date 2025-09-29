//
//  MeditationView.swift
//  SparkMind
//
//  Created by 张峰 on 2025/9/23.
//
import SwiftUI

struct iPhoneMeditationView: View {
    @StateObject private var player = AudioPlayer.shared

    private var tracks: [MeditationTrack] = {
        // existing tracks...
        let list: [(String, String)] = meditationmusic
        return list.compactMap { title, str in
            if let url = URL(string: str) { return MeditationTrack(title: title, url: url) }
            return nil
        }
    }()

    var body: some View {
        NavigationView {
            List {
                ForEach(tracks) { track in
                    VStack(spacing: 8) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(track.title)
                                    .font(.headline)
                                Text(track.url.host ?? "")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Button(action: {
                                if player.currentURL == track.url && player.isPlaying {
                                    player.pause()
                                } else {
                                    player.play(url: track.url)
                                }
                            }) {
                                Image(systemName: (player.currentURL == track.url && player.isPlaying) ? "pause.circle.fill" : "play.circle.fill")
                                    .font(.largeTitle)
                            }
                        }

                        // Progress & duration row (only active for current track)
                        if player.currentURL == track.url {
                            HStack {
                                Text(AudioPlayer.formatTime(player.currentTime))
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                    .frame(width: 44, alignment: .leading)

                                Slider(value: Binding(
                                    get: { player.currentTime },
                                    set: { newValue in player.seek(to: newValue) }
                                ), in: 0...max(1, player.duration))
                                .disabled(player.duration <= 0)

                                Text(AudioPlayer.formatTime(player.duration))
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                    .frame(width: 44, alignment: .trailing)
                            }
                        } else {
                            // show static duration for non-current tracks if available
                            HStack {
                                Spacer()
                                if player.currentURL == nil {
                                    Text("Tap play to load")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                } else {
                                    Text("--:--")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                    .padding(.vertical, 6)
                }
            }
            .navigationTitle("Meditation")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { player.stop() }) {
                        Image(systemName: "stop.fill")
                    }
                    .disabled(!player.isPlaying && player.currentURL == nil)
                }
            }
        }
    }
}

#Preview {
    iPhoneMeditationView()
}
