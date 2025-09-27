//
//  IdeaLogViewModel.swift
//  SparkMind
//
//  Created by 张峰 on 2025/9/23.
//

import Foundation
import Combine

final class IdeaLogViewModel: ObservableObject {
    @Published var notes: [Note] = [] {
        didSet {
            save()
        }
    }
    private let storageKey = "IdeaLog.notes.v1"

    init() {
        load()
    }

    func add(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        notes.insert(Note(text: trimmed), at: 0)
        save()
    }

    func remove(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
        save()
    }

    private func save() {
        if let data = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
    
    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([Note].self, from: data) else {
            notes = []
            return
        }
        notes = decoded
    }
    
    func moveToTop(id: UUID) {
        guard let idx = notes.firstIndex(where: { $0.id == id }), idx != 0 else { return }
        let item = notes.remove(at: idx)
        notes.insert(item, at: 0)
    }
}
