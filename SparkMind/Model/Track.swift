//
//  Track.swift
//  SparkMind
//
//  Created by 张峰 on 2025/9/27.
//

// swift
import Foundation

struct MeditationTrack: Identifiable, Hashable {
    let id: UUID = UUID()
    let title: String
    let url: URL

    init(title: String, url: URL) {
        self.title = title
        self.url = url
    }
}
