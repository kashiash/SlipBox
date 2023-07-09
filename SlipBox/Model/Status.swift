//
//  Status.swift
//  SlipBox
//
//  Created by Jacek Kosinski U on 09/07/2023.
//

import Foundation
enum Status: String, Identifiable,CaseIterable {
    case draft = "Draft"
    case review = "Review"
    case archived = "Archived"

    var id: String {
        return self.rawValue
    }
}
