//
//  ItemListView.swift
//  SparkMind
//
//  Created by 张峰 on 2025/9/26.
//
import SwiftUI
struct ItemListView: View {
    @Binding var section: SparkSection
    @FocusState private var focusedBackgroundTextID: UUID?
    
    var body: some View {
        ZStack {
            List {
                ForEach($section.items) { $item in
                    /*NavigationLink(item.title) {
                     BackgroundTextView(item: item)
                     }*/
                    HStack {
                        // 编辑标题（绑定到 section.title）
                        TextField("Section title", text: $item.title)
                            .font(.title2)
                            .bold()
                            .textFieldStyle(.plain)
                            .focused($focusedBackgroundTextID, equals: section.id)
                        Spacer()
                        
                        // 单独的 NavigationLink 用于导航，避免与 TextField 编辑冲突
                        NavigationLink {
                            BackgroundTextView(item: $item)
                        } label: {
                            //Image(systemName: "arrow.right")
                            //.foregroundColor(.secondary)
                        }
                        //.buttonStyle(.plain)
                    }
                    .padding(.vertical, 6)
                }
                .onDelete(perform: deleteItem)
            }
            .navigationTitle(" \(section.title)")
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
            if focusedBackgroundTextID != nil {
                Color.clear
                    .contentShape(Rectangle())
                    .ignoresSafeArea()
                    .onTapGesture {
                        focusedBackgroundTextID = nil
                        UIApplication.shared.endEditing()
                    }
            }
        }
    }

    private func addItem() {
        let newItem = SparkItem(title: "新条目 \(section.items.count + 1)", body: "这是新条目的内容。")
        section.items.append(newItem)
    }

    private func deleteItem(at offsets: IndexSet) {
        section.items.remove(atOffsets: offsets)
    }
}
