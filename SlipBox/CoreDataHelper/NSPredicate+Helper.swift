//
//  NSPredicate+Helper.swift
//  SlipBox
//
//  Created by Jacek Kosinski U on 25/06/2023.
//

import Foundation
extension NSPredicate {
    static let all = NSPredicate(format: "TRUEPREDICATE")
    static let none = NSPredicate(format: "FALSEPREDICATE")
}
