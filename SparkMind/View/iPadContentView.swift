// File: `iPadContentView.swift`
import SwiftUI

enum AppTab: String, CaseIterable, Identifiable, Hashable {
    case spark, idea, meditation
    var id: String { rawValue }
    var title: String {
        switch self {
        case .spark: return "SparkMind"
        case .idea: return "IdeaLog"
        case .meditation: return "Meditation"
        }
    }
    var icon: String {
        switch self {
        case .spark: return "sparkles"
        case .idea: return "list.bullet"
        case .meditation: return "brain.head.profile"
        }
    }
}

struct iPadContentView: View {
    @State private var selection: AppTab = .spark

    var body: some View {
        TabView(selection: $selection) {
            // SparkMind tab — preserve navigation inside this tab
            NavigationStack {
                SparkMindView()
                    .navigationTitle(AppTab.spark.title)
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Image(systemName: AppTab.spark.icon)
                Text(AppTab.spark.title)
            }
            .tag(AppTab.spark)

            // IdeaLog tab
            NavigationStack {
                IdeaLogView()
                    .navigationTitle(AppTab.idea.title)
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Image(systemName: AppTab.idea.icon)
                Text(AppTab.idea.title)
            }
            .tag(AppTab.idea)

            // Meditation tab
            NavigationStack {
                iPadMeditationView()
                    .navigationTitle(AppTab.meditation.title)
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Image(systemName: AppTab.meditation.icon)
                Text(AppTab.meditation.title)
            }
            .tag(AppTab.meditation)
        }
        // Give a sensible minimum size on iPad / Mac Catalyst
        .frame(minWidth: 700, minHeight: 500)
    }
}

#Preview {
    iPadContentView()
}
