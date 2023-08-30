//
//  FolderNotesrelationshipTests.swift
//  SlipBoxTests
//
//  Created by Jacek Kosinski U on 29/08/2023.
//

import XCTest
import CoreData
@testable import SlipBox

final class FolderNotesrelationshipTests: XCTestCase {

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

    func testNewFoldershoulhasNoNotes() {
        let folder1 = Folder(name: "Folder1", context: context)

        XCTAssertNotNil(folder1)
        XCTAssertTrue(folder1.notes.count == 0)
    }
    func testAddNoteToFolder() {
        let folder = Folder(name: "Folder", context: context)

        let note = Note(title: "new note", context: context)

        note.folder = folder

        XCTAssertTrue(folder.notes.contains(note), "There should be note in the folder")
    }

    func testDeleteNoteInFolder() {

        let folder = Folder(name: "Folder", context: context)

        let note = Note(title: "new note", context: context)

        note.folder = folder

        Note.delete(note: note)
        XCTAssertTrue(folder.notes.contains(note) == false, "There should be no note after delete")
        XCTAssertTrue(folder.notes.count == 0)
    }

    func testDeleteFolderWithNotes(){
        let folder = Folder(name: "Folder", context: context)

        let note = Note(title: "new note", context: context)

        note.folder = folder

        Folder.delete(folder)
        let retrievedNotes = try! context.fetch(Note.fetch(.all))
        let retrivedFolders = try! context.fetch(Folder.fetch(.all))
        XCTAssertTrue(retrievedNotes.count == 0, "There should be no note after delete")
        XCTAssertTrue(retrivedFolders.count == 0,"There should be no folder after delete")
    }
}
