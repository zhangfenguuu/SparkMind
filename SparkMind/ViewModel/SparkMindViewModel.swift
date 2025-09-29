//
//  SparkMindViewModel.swift
//  SparkMind
//
//  Created by 张峰 on 2025/9/25.
//
import SwiftUI
import Foundation
import Combine

final class SparkMindViewModel: ObservableObject {
    private let storageKey = "SparkMind.sections.v1"
    //private let storageKey_Item = "SparkMind.Item.v1"
    private let seededKey = "SparkMind.sections.v1.seeded"
    @Published var sections: [SparkSection] = [] {
        didSet {
            save()
        }
    }
    
    init() {
        load()
        seedIfNeeded()
    }
    
    //@State private var newSectionName = ""
    private func seedIfNeeded() {
            // Only seed once per install
            let alreadySeeded = UserDefaults.standard.bool(forKey: seededKey)
            guard !alreadySeeded else { return }
            
            // If there is existing saved content, don't overwrite it.
            if !sections.isEmpty {
                UserDefaults.standard.set(true, forKey: seededKey)
                return
            }
            
            // Sample content
            sections = [
                SparkSection(title: "行动指导", items: [
                    SparkItem(title: "保持输入", body: "读书、看电影、听音乐、和不同领域的人交流，都能在脑子里埋“火种”，灵感往往是这些碎片碰撞的火花。"),
                    SparkItem(title: "允许空白", body: "不要一直逼迫自己输出，刻意留白（散步、发呆、洗澡）时，大脑的“默认模式网络”会帮你自动整理信息。"),
                    SparkItem(title: "换个场景", body: "同一个地方久了容易陷入惯性，换到咖啡馆、公园、甚至只是移动桌椅，都可能让大脑重新活跃。"),
                    SparkItem(title: "身体运动", body: "跑步、瑜伽、快走都会提高大脑供氧，让思维更灵活。")
                ]),
                SparkSection(title: "思维模型", items: [
                    SparkItem(title: "问题 A", body: "这是一个引发思考的问题。"),
                    SparkItem(title: "第一性原理（First Principles Thinking）", body: "方法：把复杂问题拆到最基本的事实，再从零开始重建。或者从事物系统最基本的规律原理出发，解决问题。\n例子：马斯克造火箭时没接受“火箭太贵”的常识，而是问：火箭的材料实际成本是多少？结果发现远比成品便宜。\n作用：避免被传统思维框架限制。"),
                    SparkItem(title: "反向思考（Inversion）", body: "方法：不问“如何成功”，而问“怎样必然失败”，然后避免这些点。\n例子：不是问“如何提高会议效率”，而是问“怎么开会一定会低效”（比如人太多、没议程），再反过来优化。\n作用：跳出正向惯性，找到盲点。"),
                    SparkItem(title: "类比思维（Analogical Thinking）", body: "方法：把一个领域的经验借到另一个领域。\n例子：乔布斯把“书架”概念用在 iBooks 的界面里，直观又好用。\n作用：让看似无关的东西产生火花。"),
                    SparkItem(title: "系统思维（Systems Thinking）", body: "方法：把问题看成一个动态系统，关注关系、反馈和长期影响。\n例子：城市交通不仅是车的问题，还涉及公共交通、土地规划、人的行为。\n作用：帮助找到创新的杠杆点，而不是头痛医头。"),
                    SparkItem(title: "组合式创新（Combinatorial Creativity）", body: "方法：把已有元素重新组合。\n例子：iPhone = 电话 + 音乐播放器 + 网络浏览器。\n作用：灵感往往来自“旧元素的新组合”。"),
                    SparkItem(title: "二阶思维（Second-Order Thinking）", body: "方法：思考“下一步会发生什么”，而不是停在表面。\n例子：如果降低地铁票价 → 更多人乘坐 → 减少拥堵和污染 → 房价可能受影响。\n作用：避免短视，发现别人没看到的机会。"),
                    SparkItem(title: "反常识思维（Contrarian Thinking）", body: "方法：主动挑战“大家都认为正确的事”。\n例子：Airbnb 诞生于一个“谁会愿意睡在陌生人家里？”的反常识假设。\n作用：从“被忽视的角落”里挖出灵感。"),
                    SparkItem(title: "跨界迁移（Lateral Thinking", body: "方法：用跳跃、间接、奇怪的方式切入问题。\n例子：IDEO 设计购物车时，不只是问顾客，还去观察医院推车的消毒方法，得到全新思路。\n作用：突破直线思维。")
                ]),
                SparkSection(title: "跨学科知识", items: [
                    SparkItem(title: "", body: "")
                ]),
                SparkSection(title: "人物传记", items: [
                    SparkItem(title: "", body: "")
                ])
            ]
            
        
            UserDefaults.standard.set(true, forKey: seededKey)
        }
    
    func resetToSample() {
        UserDefaults.standard.set(false, forKey: seededKey)
        seedIfNeeded()
    }
    
    private func save() {
        if let data = try? JSONEncoder().encode(sections) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
    
    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([SparkSection].self, from: data) else {
            sections = []
            return
        }
        sections = decoded
    }
    
    func addSection() {
        let name = " 新分区 \(sections.count + 1)"
        sections.append(SparkSection(title: name))
        //save()
    }

    func deleteSection(at offsets: IndexSet) {
        sections.remove(atOffsets: offsets)
        //save()
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
    
    func updateTitle(for id: UUID, to newTitle: String) {
        guard let idx = sections.firstIndex(where: { $0.id == id }) else { return }
        sections[idx].title = newTitle
        //save()
    }
    
}
