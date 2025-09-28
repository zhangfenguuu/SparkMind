//
//  IdeaRow.swift
//  SparkMind
//
//  Created by 张峰 on 2025/9/26.
//
import SwiftUI
struct IdeaNoteRow: View {
    @Binding var note: Note
    var onEdit: (UUID) -> Void

    var body: some View {
        HStack(alignment: .top) {
            Text("•")
                .font(.title2)
                .foregroundColor(.blue)

            TextField("Note", text: $note.text)
                .font(.title2)
                .cornerRadius(8)
                .onChange(of: $note.text.wrappedValue) { _ in
                    onEdit($note.wrappedValue.id)
                }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
        )
        .padding(.horizontal)
    }
}
