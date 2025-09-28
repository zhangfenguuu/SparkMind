//
//  SparkMindApp.swift
//  SparkMind
//
//  Created by 张峰 on 2025/9/23.
//

import SwiftUI

@main
struct SparkMindApp: App {
    var body: some Scene {
        WindowGroup {
            if UIDevice.current.userInterfaceIdiom == .pad {
                iPadContentView()
            } else {
                iPhoneContentView()
            }
        }
    }
}
