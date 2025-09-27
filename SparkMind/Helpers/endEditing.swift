//
//  endEditing.swift
//  SparkMind
//
//  Created by 张峰 on 2025/9/23.
//

// Small helper to dismiss keyboard on iOS; safe to include for macOS too (no-op).
import UIKit
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

