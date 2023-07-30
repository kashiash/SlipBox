//
//  Keyword+Helper.swift
//  SlipBox
//
//  Created by Jacek Kosinski U on 30/07/2023.
//

import Foundation
import SwiftUI

extension Keyword {
    var colorHex: Color {
        get {
            if let colorHexValue = colorHex_,
               let color = Color(hex: colorHexValue) {
                return color
            } else {
                return Color.black
            }
        }
        set {
            colorHex_ = newValue.toHex
        }
    }
}
