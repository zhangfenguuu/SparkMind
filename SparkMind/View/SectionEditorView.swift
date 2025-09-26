//
//  SectionEditorView.swift
//  SparkMind
//
//  Created by 张峰 on 2025/9/26.
//

import SwiftUI

struct SectionEditorView: View {
    @Binding var section: SparkSection
    
    var body: some View {
        Form {
            TextField("Section Title", text: $section.title)
                .font(.title2)
                .padding()
        }
        .navigationTitle("Edit Section")
    }
}
