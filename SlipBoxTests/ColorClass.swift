//
//  ColorClass.swift
//  SlipBoxTests
//
//  Created by Jacek Kosinski U on 30/07/2023.
//

import XCTest
import SwiftUI
@testable import SlipBox

final class ColorClass: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testHexColor() {
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

}
