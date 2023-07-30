//
//  ColorClass.swift
//  SlipBoxTests
//
//  Created by Jacek Kosinski U on 30/07/2023.
//

import XCTest
import SwiftUI
import CoreData
@testable import SlipBox

final class ColorClass: XCTestCase {

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

    func testHexToColor() {
        let colorBlue = Color(hex: "0000FF")
        let colorBlueAlpha = Color(hex: "0000FFFF")

        let referenceColorBlue = Color(red: 0,green: 0,blue: 1)
        XCTAssertTrue(referenceColorBlue == colorBlue, "Converted color from x0000FF should be blue")
        XCTAssertEqual(referenceColorBlue ,colorBlue, "Converted color from x0000FF should be blue")
        XCTAssertTrue(referenceColorBlue == colorBlueAlpha, "Converted color from x0000FFFF should be blue")
    }

    func testColorToHex() {
        let referenceColorBlue = Color(red: 0,green: 0,blue: 1)
        let hex = referenceColorBlue.toHex

        XCTAssertEqual(hex,"0000FFFF", "Coverted blue color to hex should be 000000FFFF")
    }

    func testKeywordHasValidHexColor() {
        let color = Color(red: 0, green: 0, blue: 1)
        let keyword = Keyword(context: context)
        keyword.colorHex = color
        let retrievedColor = keyword.colorHex

        XCTAssertTrue(retrievedColor == color , "Keyword color should be blue")
    }

}
