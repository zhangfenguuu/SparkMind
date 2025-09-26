//
//  IdeaLog.swift
//  SparkMind
//
//  Created by 张峰 on 2025/9/23.
//

import Foundation

struct Note: Identifiable, Codable, Equatable {
    let id: UUID
    var text: String
    var createdAt: Date

    init(text: String) {
        self.id = UUID()
        self.text = text
        self.createdAt = Date()
    }
}
