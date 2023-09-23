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

    func testFetchTopFolders() {
        let parent = Folder(name:"parent",context: context)
        let child = Folder(name: "child", context: context)
        parent.subfolders.insert(child)

        let predicate = NSPredicate(format: "parent == nil")
        let fetchRequest = Folder.fetch(predicate)

        let retrievedFolders = try! context.fetch(fetchRequest)

        XCTAssertTrue(retrievedFolders.count == 1)
        XCTAssertTrue(retrievedFolders.contains(parent))

        let fetchRequestNew = Folder.fetchTopFolders()
        let rerievedTopFolders = try! context.fetch(fetchRequestNew)
        XCTAssertTrue(rerievedTopFolders.count == 1)
        XCTAssertTrue(rerievedTopFolders.contains(parent))

                      }

    func testFetchTop2Folders(){
        let parent1 = Folder(name:"parent",context: context)
        let parent2 = Folder(name:"parent",context: context)
        let parent3 = Folder(name:"parent",context: context)

        let fetchRequestNew =  Folder.fetchTopFolders()
        fetchRequestNew.fetchLimit = 2
        let rerievedTopFolders = try! context.fetch(fetchRequestNew)

        XCTAssertTrue(rerievedTopFolders.count == 2)
        XCTAssertTrue(rerievedTopFolders.contains(parent1))
    }

    func testFetchTopFoldersWithBatchSize(){
        let parent1 = Folder(name:"parent",context: context)
        let parent2 = Folder(name:"parent",context: context)
        let parent3 = Folder(name:"parent",context: context)

        let fetchRequestNew =  Folder.fetchTopFolders()
        fetchRequestNew.fetchBatchSize = 2
        let rerievedTopFolders = try! context.fetch(fetchRequestNew)

        XCTAssertTrue(rerievedTopFolders.count == 3)
        XCTAssertTrue(rerievedTopFolders.contains(parent1))
    }

}
