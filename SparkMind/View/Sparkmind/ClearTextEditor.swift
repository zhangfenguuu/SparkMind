//
//  ClearTextEditor.swift
//  SparkMind
//
//  Created by 张峰 on 2025/9/27.
//

// swift
import SwiftUI

struct ClearTextEditor: UIViewRepresentable {
    @Binding var text: String
    var font: UIFont?

    func makeCoordinator() -> Coordinator { Coordinator(parent: self) }

    func makeUIView(context: Context) -> UITextView {
        let tv = UITextView()
        tv.backgroundColor = .clear              // keep background transparent
        tv.isScrollEnabled = true
        tv.isEditable = true
        tv.font = font
        tv.delegate = context.coordinator
        tv.textContainerInset = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
        tv.textContainer.lineFragmentPadding = 0
        tv.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        tv.keyboardDismissMode = .interactive
        return tv
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
        if uiView.font != font {
            uiView.font = font
        }
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: ClearTextEditor
        init(parent: ClearTextEditor) { self.parent = parent }

        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
    }
}

#Preview {
    ClearTextEditor(text: .constant("This is a test of the ClearTextEditor.\nIt should have a transparent background."), font: UIFont.preferredFont(forTextStyle: .body))
}
