//
//  Color+Extentions.swift
//  PlenyAssessment
//
//  Created by Abdalla Elsaman on 13/03/2025.
//

import SwiftUI

extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "#", with: "")
        
        // If the hex code is 6 characters, use RGB. If it's 8 characters, use RGBA (with alpha value).
        if hexSanitized.count == 6 {
            hexSanitized = "FF" + hexSanitized  // Add full opacity (FF) by default
        }
        
        if hexSanitized.count == 8, let hexValue = UInt32(hexSanitized, radix: 16) {
            let red = Double((hexValue >> 24) & 0xFF) / 255.0
            let green = Double((hexValue >> 16) & 0xFF) / 255.0
            let blue = Double((hexValue >> 8) & 0xFF) / 255.0
            let alpha = Double(hexValue & 0xFF) / 255.0
            self.init(red: red, green: green, blue: blue, opacity: alpha)
        } else {
            // Default to white if the hex code is invalid
            self.init(red: 1.0, green: 1.0, blue: 1.0)
        }
    }
}
