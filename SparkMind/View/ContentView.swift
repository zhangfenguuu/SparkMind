//
//  ContentView.swift
//  SparkMind
//
//  Created by 张峰 on 2025/9/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            SparkMindView()
                .tabItem {
                    Image(systemName: "sparkles")
                    Text("SparkMind")
                }
            
            IdeaLogView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("IdeaLog")
                }

            MeditationView()
                .tabItem {
                    Image(systemName: "brain.head.profile")
                    Text("Meditation")
                }
            
        }
    }
}

#Preview {
    ContentView()
}
