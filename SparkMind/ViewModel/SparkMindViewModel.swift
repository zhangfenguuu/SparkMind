//
//  SparkMindViewModel.swift
//  SparkMind
//
//  Created by 张峰 on 2025/9/25.
//
import SwiftUI

class SparkMindViewModel: ObservableObject {
    @Published var sections: [SparkSection] = [
        SparkSection(title: "行动指导", items: [
            SparkItem(title: "第一个灵感", body: "这里展示灵感内容。")
        ]),
        SparkSection(title: "思维模型", items: [
            SparkItem(title: "问题 A", body: "这是一个引发思考的问题。")
        ]),
        SparkSection(title: "思维训练", items: [
            SparkItem(title: "问题 A", body: "这是一个引发思考的问题。")
        ])
    ]
    
    @State private var newSectionName = ""
    
    func addSection() {
        let name = " 新分区 \(sections.count + 1)"
        sections.append(SparkSection(title: name))
    }

    func deleteSection(at offsets: IndexSet) {
        sections.remove(atOffsets: offsets)
    }

    /*func binding(for section: SparkSection) -> Binding<SparkSection> {
        guard let idx = sections.firstIndex(where: { $0.id == section.id }) else {
            fatalError("Section not found")
        }
        return self.sections[idx]
    }*/
    
    func idx(for section: SparkSection) -> Int {
        guard let idx = sections.firstIndex(where: { $0.id == section.id }) else {
            fatalError("Section not found")
        }
        return idx
    }
    /*
    private func addItem() {
        let newItem = sSparkItem(title: "新条目 \(section.items.count + 1)", body: "这是新条目的内容。")
        section.items.append(newItem)
    }

    private func deleteItem(at offsets: IndexSet) {
        section.items.remove(atOffsets: offsets)
    }
     */
}
