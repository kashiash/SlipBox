//
//  NotesTests.swift
//  SlipBoxTests
//
//  Created by Jacek Kosinski U on 30/06/2023.
//

import XCTest
@testable import SlipBox
import CoreData

final class NotesTests: XCTestCase {

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

    func testNotesConvenceInit() {
        let noteTitle = "new"
        let note = Note(title:noteTitle, context: context)

        XCTAssertTrue(note.title == noteTitle, "note should have the title given in convenience initializer")
    }
    func testNotesCreationdate(){
        let note = Note(context:context)
        let noteConvenient = Note(title: "new", context: context)

        XCTAssertNotNil(note.creationDate, "notes should have creation date property filled")
        XCTAssertNotNil(noteConvenient.creationDate, "notes should have creation date property filled")
    }

    func testNotesUpdatingTitle() {
        let note = Note(title: "old", context: context)
        note.title = "new"

        XCTAssertTrue(note.title == "new")
    }

    func testFetchAllNotesPredicate(){
        let note = Note(title: "default note", context: context)
        let fetch = Note.fetch(.all)

        let fetchedNotes = try? context.fetch(fetch)

        XCTAssertNotNil(fetchedNotes)
        XCTAssertTrue(fetchedNotes!.count > 0, "Redicate none should  fetch some objects")

    }

    func testFetchNoneNotesPredicate(){
        let note = Note(title: "default note", context: context)
        let fetch = Note.fetch(.none)

        let fetchedNotes = try? context.fetch(fetch)

        XCTAssertNotNil(fetchedNotes)
        XCTAssertTrue(fetchedNotes!.count == 0, "Redicate none should not fetch any objects")

    }

}
