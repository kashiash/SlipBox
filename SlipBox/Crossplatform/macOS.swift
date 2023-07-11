//
//  macOS.swift
//  SlipBox
//
//  Created by Jacek Kosinski U on 11/07/2023.
//

import SwiftUI

typealias UIImage = NSImage

extension Image {
    init(uiImage: UIImage){
        self.init(nsImage: uiImage)
    }
}
