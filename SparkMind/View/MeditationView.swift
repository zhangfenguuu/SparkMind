//
//  MeditationView.swift
//  SparkMind
//
//  Created by 张峰 on 2025/9/23.
//

import SwiftUI

struct MeditationTrack: Identifiable {
    let id = UUID()
    let title: String
    let url: URL
}

struct MeditationView: View {
    @StateObject private var player = AudioPlayer()

    // Example tracks: replace with local bundle files if desired.
    private var tracks: [MeditationTrack] = {
        // Replace these URLs with your own hosted audio or use Bundle.main.url(forResource:..., withExtension:...)
        let list = [
            ("Calm Waves", "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3"),
            ("Gentle Rain", "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3"),
            ("Soft Piano", "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3")
        ]
        return list.compactMap { title, str in
            if let url = URL(string: str) { return MeditationTrack(title: title, url: url) }
            return nil
        }
    }()

    var body: some View {
        NavigationView {
            List {
                ForEach(tracks) { track in
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
    MeditationView()
}
