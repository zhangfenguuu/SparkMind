//
//  iPadMeditationView.swift
//  SparkMind
//
//  Created by 张峰 on 2025/9/28.
//
// File: `iPadMeditationView.swift`
// swift
// File: `iPadMeditationView.swift`
import SwiftUI

struct iPadMeditationView: View {
    @StateObject private var player = AudioPlayer.shared
    @State private var selectedTrack: MeditationTrack?

    private let tracks: [MeditationTrack] = {
        let list: [(String, String)] = meditationmusic
        return list.compactMap { title, str in
            if let url = URL(string: str) { return MeditationTrack(title: title, url: url) }
            return nil
        }
    }()

    // fixed height for the bottom player area
    private let playerHeight: CGFloat = 180

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Track list fills remaining space above player
                List(tracks) { track in
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(track.title)
                                .font(.headline)
                            Text(track.url.host ?? "")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }

                        Spacer()

                        Button(action: { togglePlay(for: track) }) {
                            Image(systemName: isPlaying(track: track) ? "pause.circle.fill" : "play.circle.fill")
                                .font(.title)
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel(isPlaying(track: track) ? "Pause" : "Play")
                    }
                    .padding(.vertical, 6)
                    .contentShape(Rectangle())
                    .background(selectedTrack?.id == track.id ? Color(.systemGray5) : Color.clear)
                    .onTapGesture {
                        withAnimation { selectedTrack = track }
                    }
                }
                .listStyle(.plain)
                .frame(maxHeight: .infinity)

                Divider()

                // Bottom player panel
                Group {
                    if let track = selectedTrack ?? tracks.first {
                        VStack(spacing: 12) {
                            // Title row (left aligned)
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(track.title)
                                        .font(.headline)
                                    Text(track.url.host ?? "")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                            }

                            // Centered controls row
                            HStack {
                                Spacer()
                                HStack(spacing: 24) {
                                    Button(action: { player.stop(); selectedTrack = nil }) {
                                        Image(systemName: "stop.fill")
                                            .font(.title2)
                                    }
                                    .disabled(!player.isPlaying && player.currentURL == nil)

                                    Button(action: { togglePlay(for: track) }) {
                                        Image(systemName: isPlaying(track: track) ? "pause.circle.fill" : "play.circle.fill")
                                            .resizable()
                                            .frame(width: 56, height: 56)
                                    }
                                    .buttonStyle(.plain)
                                    .accessibilityLabel(isPlaying(track: track) ? "Pause" : "Play")
                                }
                                Spacer()
                            }

                            // Progress row
                            HStack {
                                Text(AudioPlayer.formatTime(player.currentTime))
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                    .frame(width: 48, alignment: .leading)

                                Slider(value: Binding(
                                    get: { player.currentTime },
                                    set: { newValue in player.seek(to: newValue) }
                                ), in: 0...max(1, player.duration))
                                .disabled(player.duration <= 0)

                                Text(AudioPlayer.formatTime(player.duration))
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                    .frame(width: 48, alignment: .trailing)
                            }
                        }
                        .padding()
                        .frame(height: playerHeight)
                        .background(.regularMaterial)
                    } else {
                        VStack {
                            Text("Select a track")
                                .foregroundColor(.secondary)
                        }
                        .frame(height: playerHeight)
                        .frame(maxWidth: .infinity)
                        .background(.regularMaterial)
                    }
                }
            }
            .navigationTitle("Meditation")
            .onAppear {
                if selectedTrack == nil { selectedTrack = tracks.first }
            }
        }
    }

    // Helpers
    private func isPlaying(track: MeditationTrack) -> Bool {
        return player.currentURL == track.url && player.isPlaying
    }

    private func togglePlay(for track: MeditationTrack) {
        selectedTrack = track
        if isPlaying(track: track) {
            player.pause()
        } else {
            player.play(url: track.url)
        }
    }
}

#Preview {
    iPadMeditationView()
}
