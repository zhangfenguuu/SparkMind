//
//  IdeaLogView.swift
//  SparkMind
//
//  Created by 张峰 on 2025/9/23.
//

import SwiftUI
/*
struct IdeaLogView: View {
    @StateObject private var vm = IdeaLogViewModel()
    @State private var draft = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 输入区域
                HStack {
                    TextField("New idea...", text: $draft)
                        .padding(12)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .font(.title3)

                    Button(action: {
                        vm.add(draft)
                        draft = ""
                        UIApplication.shared.endEditing()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    .disabled(draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding(.horizontal)
                .padding(.top)

                // 列表
                List {
                    ForEach($vm.notes) { $note in
                        HStack(alignment: .top) {
                            Text("•")
                                .font(.title2)
                                .foregroundColor(.blue)
                            TextField("Section title", text: $note.text)
                                .font(.title2)
                                .cornerRadius(8)
                                .onChange(of: $note.text.wrappedValue) { _ in
                                    let id = note.wrappedValue.id
                                    withAnimation {
                                        vm.moveToTop(id: id)
                                    }
                                }
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemGray6))
                            .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2))
                        .padding(.horizontal)
                    }
                    .onDelete(perform: vm.remove)
                }
                .listStyle(.plain)

            }
            .navigationTitle("IdeaLog")
            .background(Color(.white).ignoresSafeArea())
        }
    }
}
*/


import SwiftUI

struct IdeaLogView: View {
    @StateObject private var vm = IdeaLogViewModel()
    @State private var draft = ""
    @FocusState private var focusedSectionID: UUID?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Input area
                HStack {
                    TextField("New idea...", text: $draft)
                        .padding(12)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .font(.title3)

                    Button(action: {
                        vm.add(draft)
                        draft = ""
                        UIApplication.shared.endEditing()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    .disabled(draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding(.horizontal)
                .padding(.top)

                // List with lightweight rows
                List {
                    ForEach($vm.notes) { $note in
                        IdeaNoteRow(note: $note) { id in
                            withAnimation {
                                vm.moveToTop(id: id)
                            }
                        }
                        .focused($focusedSectionID, equals: note.id)
                    }
                    .onDelete(perform: vm.remove)
                }
                .listStyle(.plain)
                
                
                Color.clear
                    .contentShape(Rectangle())
                    .ignoresSafeArea()
                    .onTapGesture {
                        focusedSectionID = nil
                        UIApplication.shared.endEditing()
                    }
                
                
            }
            .navigationTitle("IdeaLog")
            .background(Color(.white).ignoresSafeArea())
        }
    }
}


#Preview {
    IdeaLogView()
}
