//
//  FolderTests.swift
//  SlipBoxTests
//
//  Created by Jacek Kosinski U on 28/08/2023.
//

import XCTest
@testable import SlipBox
import CoreData

final class FolderTests: XCTestCase {

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

    func testFolderShouldHaveCreationDate(){
        let folder = Folder(name: "new folder", context: context)

        XCTAssertNotNil(folder.creationDate_, "Folder should have creation date")
    }
    func testFetchAllFolders() {
        let folder1 = Folder(name: "FirstFolder", context: context)
        let folder2 = Folder(name: "SecondFolder", context: context)
        let folder3 = Folder(name: "ThirdFolder", context: context)

        let request = Folder.fetch(.all)

        let retrivedFolders = try? context.fetch(request)

        XCTAssertNotNil(retrivedFolders)

        XCTAssertTrue(retrivedFolders?.count == 3, "response should have 3 folders")

        XCTAssertTrue(retrivedFolders!.contains(folder1))
        XCTAssertTrue(retrivedFolders!.contains(folder2), "response shpuld contain folder2")
        XCTAssertTrue(retrivedFolders!.contains(folder3), "response shpuld contain folder3")

        XCTAssertTrue(retrivedFolders?.first   == folder1)
        XCTAssertTrue(retrivedFolders?.last   == folder3)
    }

}
