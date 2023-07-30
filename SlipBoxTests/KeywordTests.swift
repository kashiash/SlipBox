//
//  KeywordTests.swift
//  SlipBoxTests
//
//  Created by Jacek Kosinski U on 30/07/2023.
//

import XCTest
import SwiftUI
import CoreData
@testable import SlipBox

final class KeywordTests: XCTestCase {

    var controller : PersistenceController!
    var context:NSManagedObjectContext {
        controller.container.viewContext
    }

    override func setUpWithError() throws {
        self.controller = PersistenceController.createEmptyStore()
    }

    override func tearDownWithError() throws {
        self.controller = nil
    }

    
    func testKeywordHasValidHexColor() {
        let color = Color(red: 0, green: 0, blue: 1)
        let keyword = Keyword(context: context)
        keyword.colorHex = color
        let retrievedColor = keyword.colorHex

        XCTAssertTrue(retrievedColor == color , "Keyword color should be blue")
    }

    func testKeywordDefaultColor() {
        let referenceColor = Color.black
        let keyword = Keyword(context: context)

        let retrievedColor = keyword.color
        XCTAssertTrue(retrievedColor == referenceColor , "Keyword default color should be black")
    }

    func testKeywordComponentHasValidHexColor() {
        let referenceColor = Color(red: 0, green: 0, blue: 1)
        let keyword = Keyword(context: context)
        keyword.color = referenceColor
        let retrievedColor = keyword.color

        XCTAssertTrue(retrievedColor == referenceColor , "Keyword set by component fields, color should be blue")
    }
}
