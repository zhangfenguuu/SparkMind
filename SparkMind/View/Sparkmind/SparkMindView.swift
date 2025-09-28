//
//  SparkMindView.swift
//  SparkMind
//
//  Created by 张峰 on 2025/9/25.
//

// Swift
import SwiftUI

struct SparkMindView: View {
    
    @StateObject private var vm = SparkMindViewModel()
    @FocusState private var focusedSectionID: UUID?
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                // 背景图片
                if UIDevice.current.userInterfaceIdiom == .pad {
                    if UIImage(named: "background") != nil {
                        Image("background")
                            .resizable()
                            .scaleEffect(x: 1.1, y: 0.7, anchor: .center)
                            .opacity(0.3)
                            .ignoresSafeArea()
                    }
                } else {
                    if UIImage(named: "background") != nil {
                        Image("background")
                            .resizable()
                            .scaleEffect(x: 1.5, y: 0.7, anchor: .center)
                            .opacity(0.3)
                            .ignoresSafeArea()
                    }
                }
        
        
                // 列表内容 — 使用 binding ForEach 以便直接编辑 title
                List {
                    ForEach($vm.sections) { $section in
                        HStack {
                            // 编辑标题（绑定到 section.title）
                            TextField("Section title", text: $section.title)
                                .font(.title2)
                                .bold()
                                .textFieldStyle(.plain)
                                .focused($focusedSectionID, equals: section.id)
                                .onChange(of: section.title) { title in
                                    vm.updateTitle(for: section.id, to: title)
                                }
                            Spacer()
                            
                            // 单独的 NavigationLink 用于导航，避免与 TextField 编辑冲突
                            NavigationLink {
                                ItemListView(section: $section)
                            } label: {
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.vertical, 6)
                        //.contentShape(Rectangle())
                    }
                    .onDelete(perform: vm.deleteSection)
                }
                .scrollContentBackground(.hidden) // 隐藏 List 默认背景
                
                if focusedSectionID != nil {
                    Color.clear
                        .contentShape(Rectangle())
                        .ignoresSafeArea()
                        .onTapGesture {
                            focusedSectionID = nil
                            UIApplication.shared.endEditing()
                        }
                }
            }
            .navigationTitle("SparkMind")
            .overlay(
                Button(action: { vm.addSection() }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                }
                .padding(.bottom, 25),
                alignment: .bottom
            )
            
        }
    }
}
#Preview {
    SparkMindView()
}
