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
    @StateObject private var player = AudioPlayer()
    @State private var selectedTrack: MeditationTrack?

    private let tracks: [MeditationTrack] = {
        let list: [(String, String)] = [
            ("水晶能量", "https://meditation-zf.oss-cn-shenzhen.aliyuncs.com/%E4%B8%AA%E4%BA%BA%E6%94%B6%E8%97%8F%E5%86%A5%E6%83%B3%E9%9F%B3%E4%B9%90%E5%90%88%E9%9B%86/4096Hz%E6%B0%B4%E6%99%B6%E8%83%BD%E9%87%8F.mp3"),
            ("梦", "https://meditation-zf.oss-cn-shenzhen.aliyuncs.com/%E4%B8%AA%E4%BA%BA%E6%94%B6%E8%97%8F%E5%86%A5%E6%83%B3%E9%9F%B3%E4%B9%90%E5%90%88%E9%9B%86/%E3%80%8A%E6%A2%A6%E3%80%8B-2018%E5%B9%B44%E6%9C%88.mp3"),
            ("伊西丝女神能量","https://meditation-zf.oss-cn-shenzhen.aliyuncs.com/%E4%B8%AA%E4%BA%BA%E6%94%B6%E8%97%8F%E5%86%A5%E6%83%B3%E9%9F%B3%E4%B9%90%E5%90%88%E9%9B%86/%E4%BC%8A%E8%A5%BF%E4%B8%9D%E5%A5%B3%E7%A5%9E%E8%83%BD%E9%87%8F.mp3"),
            ("合一本源引导","https://meditation-zf.oss-cn-shenzhen.aliyuncs.com/%E4%B8%AA%E4%BA%BA%E6%94%B6%E8%97%8F%E5%86%A5%E6%83%B3%E9%9F%B3%E4%B9%90%E5%90%88%E9%9B%86/%E5%90%88%E4%B8%80%E6%9C%AC%E6%BA%90%E5%BC%95%E5%AF%BC%E9%9F%B3%E9%A2%91.mp3"),
            ("唤醒内在神圣自我","https://meditation-zf.oss-cn-shenzhen.aliyuncs.com/%E4%B8%AA%E4%BA%BA%E6%94%B6%E8%97%8F%E5%86%A5%E6%83%B3%E9%9F%B3%E4%B9%90%E5%90%88%E9%9B%86/%E5%94%A4%E9%86%92%E5%86%85%E5%9C%A8%E7%A5%9E%E5%9C%A3%E8%87%AA%E6%88%91.mp3"),
            ("女神漩涡冥想","https://meditation-zf.oss-cn-shenzhen.aliyuncs.com/%E4%B8%AA%E4%BA%BA%E6%94%B6%E8%97%8F%E5%86%A5%E6%83%B3%E9%9F%B3%E4%B9%90%E5%90%88%E9%9B%86/%E5%A5%B3%E7%A5%9E%E6%BC%A9%E6%B6%A1%E5%86%A5%E6%83%B3.mp3"),
            ("开启松果体","https://meditation-zf.oss-cn-shenzhen.aliyuncs.com/%E4%B8%AA%E4%BA%BA%E6%94%B6%E8%97%8F%E5%86%A5%E6%83%B3%E9%9F%B3%E4%B9%90%E5%90%88%E9%9B%86/%E5%BC%80%E5%90%AF%E6%9D%BE%E6%9E%9C%E4%BD%93.mp3"),
            ("无路之路引导指引","https://meditation-zf.oss-cn-shenzhen.aliyuncs.com/%E4%B8%AA%E4%BA%BA%E6%94%B6%E8%97%8F%E5%86%A5%E6%83%B3%E9%9F%B3%E4%B9%90%E5%90%88%E9%9B%86/%E6%97%A0%E8%B7%AF%E4%B9%8B%E8%B7%AF%E5%86%A5%E6%83%B3%E5%BC%95%E5%AF%BC.mp3"),
            ("昆达里尼能量提升","https://meditation-zf.oss-cn-shenzhen.aliyuncs.com/%E4%B8%AA%E4%BA%BA%E6%94%B6%E8%97%8F%E5%86%A5%E6%83%B3%E9%9F%B3%E4%B9%90%E5%90%88%E9%9B%86/%E6%98%86%E8%BE%BE%E9%87%8C%E5%B0%BC%E8%83%BD%E9%87%8F%E6%8F%90%E5%8D%87.mp3"),
            ("极致美丽","https://meditation-zf.oss-cn-shenzhen.aliyuncs.com/%E4%B8%AA%E4%BA%BA%E6%94%B6%E8%97%8F%E5%86%A5%E6%83%B3%E9%9F%B3%E4%B9%90%E5%90%88%E9%9B%86/%E6%9E%81%E8%87%B4%E7%BE%8E%E4%B8%BD.mp3"),
            ("沐浴在光中","https://meditation-zf.oss-cn-shenzhen.aliyuncs.com/%E4%B8%AA%E4%BA%BA%E6%94%B6%E8%97%8F%E5%86%A5%E6%83%B3%E9%9F%B3%E4%B9%90%E5%90%88%E9%9B%86/%E6%B2%90%E6%B5%B4%E5%9C%A8%E5%85%89%E4%B8%AD.mp3"),
            ("激活七大主脉轮","https://meditation-zf.oss-cn-shenzhen.aliyuncs.com/%E4%B8%AA%E4%BA%BA%E6%94%B6%E8%97%8F%E5%86%A5%E6%83%B3%E9%9F%B3%E4%B9%90%E5%90%88%E9%9B%86/%E6%B8%85%E7%90%86%E5%92%8C%E6%BF%80%E6%B4%BB%E4%B8%83%E5%A4%A7%E4%B8%BB%E8%84%89%E8%BD%AE.mp3"),
            ("激活大脑潜力贝塔波","https://meditation-zf.oss-cn-shenzhen.aliyuncs.com/%E4%B8%AA%E4%BA%BA%E6%94%B6%E8%97%8F%E5%86%A5%E6%83%B3%E9%9F%B3%E4%B9%90%E5%90%88%E9%9B%86/%E6%BF%80%E6%B4%BB%E5%A4%A7%E8%84%91%E6%BD%9C%E5%8A%9B%E9%A2%91%E7%8E%87Beta%E6%B3%A2.mp3"),
            ("激活昆达里尼能量","https://meditation-zf.oss-cn-shenzhen.aliyuncs.com/%E4%B8%AA%E4%BA%BA%E6%94%B6%E8%97%8F%E5%86%A5%E6%83%B3%E9%9F%B3%E4%B9%90%E5%90%88%E9%9B%86/%E6%BF%80%E6%B4%BB%E6%98%86%E8%BE%BE%E9%87%8C%E5%B0%BC%E8%83%BD%E9%87%8F.mp3"),
            ("触碰内在女性能量面相","https://meditation-zf.oss-cn-shenzhen.aliyuncs.com/%E4%B8%AA%E4%BA%BA%E6%94%B6%E8%97%8F%E5%86%A5%E6%83%B3%E9%9F%B3%E4%B9%90%E5%90%88%E9%9B%86/%E8%A7%A6%E7%A2%B0%E5%86%85%E5%9C%A8%E5%A5%B3%E6%80%A7%E8%83%BD%E9%87%8F%E9%9D%A2%E7%9B%B8.mp3"),
            ("颂唱毗湿奴","https://meditation-zf.oss-cn-shenzhen.aliyuncs.com/%E4%B8%AA%E4%BA%BA%E6%94%B6%E8%97%8F%E5%86%A5%E6%83%B3%E9%9F%B3%E4%B9%90%E5%90%88%E9%9B%86/%E9%A2%82%E5%94%B1%E6%AF%97%E6%B9%BF%E5%A5%B4.mp3")
        ]
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
