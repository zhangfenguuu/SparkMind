//
//  BackgroundTextView.swift
//  SparkMind
//
//  Created by 张峰 on 2025/9/26.
//

// swift
import SwiftUI

struct BackgroundTextView: View {
    @Binding var item: SparkItem
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                if UIDevice.current.userInterfaceIdiom == .pad {
                    if UIImage(named: "zf") != nil {
                        Image("zf")
                            .resizable()
                            .scaledToFill()
                            .scaleEffect(x: 1, y: 1.2, anchor: .center)
                            .frame(width: geo.size.width, height: geo.size.height)
                            .clipped()
                    }
                } else {
                    if UIImage(named: "zf") != nil {
                        Image("zf")
                            .resizable()
                            .scaledToFill()
                            .scaleEffect(x: 1, y: 1.2, anchor: .center)
                            .frame(width: geo.size.width, height: geo.size.height)
                            .clipped()
                    }
                }

                VStack(alignment: .leading, spacing: 16) {
                    TextField("Title", text: $item.title)
                        .font(.largeTitle)
                        .bold()
                        .textFieldStyle(.plain)

                    ZStack(alignment: .topLeading) {
                        // Use custom clear-background editor so background image remains visible
                        ClearTextEditor(text: $item.body, font: UIFont.preferredFont(forTextStyle: .title2))
                            .frame(minHeight: 200)
                            .cornerRadius(8)

                        if item.body.isEmpty {
                            Text("")
                                .foregroundColor(.secondary)
                                .padding(.top, 12)
                                .padding(.leading, 6)
                                .allowsHitTesting(false)
                        }
                    }
                }
                .padding(24)
                .cornerRadius(12)
                .padding()
            }
        }
    }
}

#Preview {
    BackgroundTextView(item: .constant(SparkItem(title: "示例标题", body: "这是示例内容。hahahahahhahahahahhahahahahahahahahah")))
}
