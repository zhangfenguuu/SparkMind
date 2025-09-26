//
//  SparkPage.swift
//  SparkMind
//
//  Created by 张峰 on 2025/9/25.
//

import SwiftUI

struct SparkSection: Identifiable, Hashable {
    var id = UUID()
    var title: String
    var items: [SparkItem] = []
}

struct SparkItem: Identifiable, Hashable {
    var id = UUID()
    var title: String
    var body: String
}
