//
//  BackgroundTextView.swift
//  SparkMind
//
//  Created by 张峰 on 2025/9/26.
//

import SwiftUI

struct BackgroundTextView: View {
    @Binding var item: SparkItem

    var body: some View {
        GeometryReader { geo in
            ZStack {
                if UIImage(named: "background") != nil {
                    Image("background")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.height)
                        .clipped()
                } else {
                    LinearGradient(colors: [.blue, .purple], startPoint: .top, endPoint: .bottom)
                        .ignoresSafeArea()
                }

                VStack(alignment: .leading, spacing: 16) {
                    /*Text(item.title)
                        .font(.largeTitle)
                        .bold()*/
                    TextField("Section title", text: $item.title)
                        .font(.largeTitle)
                        .bold()
                        .textFieldStyle(.plain)
                    ScrollView {
                        TextField("Section title", text: $item.body)
                            //.font(.title2)
                            //.bold()
                            .textFieldStyle(.plain)
                            .font(.title2)
                            .padding(.bottom, 40)
                    }
                }
                .padding(24)
                //.background(.ultraThinMaterial)
                .cornerRadius(12)
                .padding()
            }
        }
        //.navigationTitle(item.title)
    }
}

#Preview {
    BackgroundTextView(item: .constant(SparkItem(title: "示例标题", body: "这是示例内容。")))
}
