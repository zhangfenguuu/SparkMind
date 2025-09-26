//
//  s.swift
//  SparkMind
//
//  Created by 张峰 on 2025/9/25.
//

import SwiftUI

// SparkMindView.swift
// SwiftUI view with 2-level navigation:
// - Navigation1: list of sections (用户可添加/删除)
// - Navigation2: detail list for each section (用户可添加/删除)，点开后显示背景图 + 文字

struct sSparkSection: Identifiable, Hashable {
    var id = UUID()
    var title: String
    var items: [sSparkItem] = []
}

struct sSparkItem: Identifiable, Hashable {
    var id = UUID()
    var title: String
    var body: String
}

struct sSparkMindView: View {
    @State private var sections: [sSparkSection] = [
        sSparkSection(title: "行动指导", items: [
            sSparkItem(title: "第一个灵感", body: "这里展示灵感内容。")
        ]),
        sSparkSection(title: "思维模型", items: [
            sSparkItem(title: "问题 A", body: "这是一个引发思考的问题。")
        ]),
        sSparkSection(title: "思维训练", items: [
            sSparkItem(title: "问题 A", body: "这是一个引发思考的问题。")
        ])
    ]

    @State private var newSectionName = ""

    var body: some View {
        
        NavigationStack {
            ZStack {
                // 背景图片
                if UIImage(named: "background") != nil {
                    Image("background")
                        .resizable()
                        .scaleEffect(x: 1.5, y: 1.0, anchor: .center)
                        //.scaledToFill()
                        //.ignoresSafeArea()
                        .opacity(0.3)
                }

                // 列表内容
                List {
                    ForEach(sections) { section in
                        NavigationLink(destination: sItemListView(section: sbinding(for: section))) {
                            Text(section.title)
                                .font(.title2)
                                .bold()
                                .padding()
                        }
                    }
                    .onDelete(perform: deleteSection)
                }
                .scrollContentBackground(.hidden) //  隐藏 List 默认背景
            }
            .navigationTitle("SparkMind")
            .overlay(
                Button(action: { addSection() }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                }
                .padding(.bottom, 25),
                alignment: .bottom
            )
        }
    }

    private func addSection() {
        let name = "新分区 \(sections.count + 1)"
        sections.append(sSparkSection(title: name))
    }

    private func deleteSection(at offsets: IndexSet) {
        sections.remove(atOffsets: offsets)
    }

    private func sbinding(for section: sSparkSection) -> Binding<sSparkSection> {
        guard let idx = sections.firstIndex(where: { $0.id == section.id }) else {
            fatalError("Section not found")
        }
        return $sections[idx]
    }
}

struct sItemListView: View {
    @Binding var section: sSparkSection

    var body: some View {
        List {
            ForEach(section.items) { item in
                NavigationLink(item.title) {
                    sBackgroundTextView(item: item)
                }
            }
            .onDelete(perform: deleteItem)
        }
        .navigationTitle("导航2: \(section.title)")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { addItem() }) {
                    Label("Add", systemImage: "plus")
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                EditButton()
            }
        }
    }

    private func addItem() {
        let newItem = sSparkItem(title: "新条目 \(section.items.count + 1)", body: "这是新条目的内容。")
        section.items.append(newItem)
    }

    private func deleteItem(at offsets: IndexSet) {
        section.items.remove(atOffsets: offsets)
    }
}

struct sBackgroundTextView: View {
    var item: sSparkItem

    var body: some View {
        GeometryReader { geo in
            ZStack {
                if UIImage(named: "background") != nil {
                    Image("background")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.height)
                        .clipped()
                } else {
                    LinearGradient(colors: [.blue, .purple], startPoint: .top, endPoint: .bottom)
                        .ignoresSafeArea()
                }

                VStack(alignment: .leading, spacing: 16) {
                    Text(item.title)
                        .font(.largeTitle)
                        .bold()
                    ScrollView {
                        Text(item.body)
                            .font(.body)
                            .padding(.bottom, 40)
                    }
                }
                .padding(24)
                //.background(.ultraThinMaterial)
                .cornerRadius(12)
                .padding()
            }
        }
        .navigationTitle(item.title)
    }
}

#Preview {
    sSparkMindView()
}

/*
struct SparkMindView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            Image("background")
                .resizable()
                .scaledToFill()
                .frame(width: geo.size.width, height: geo.size.height)
                .clipped()
        }
    }
}*/
