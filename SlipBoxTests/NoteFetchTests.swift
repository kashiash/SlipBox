//
//  NoteFetchTests.swift
//  SlipBoxTests
//
//  Created by Jacek Kosinski U on 24/09/2023.
//

import XCTest
@testable import SlipBox
import CoreData

final class NoteFetchTest: XCTestCase {

    var controller: PersistenceController!

    var context: NSManagedObjectContext {
        controller.container.viewContext
    }

    override func setUpWithError() throws {
        self.controller = PersistenceController.createEmptyStore()
    }

    override func tearDownWithError() throws {
        self.controller = nil
    }

    func test_search_term_notes() {
        let note1 = Note(title: "Täst", context: context)
        let note2 = Note(title: "Dummy", context: context)

        let searchTerm = "tast"

        let predicate = NSPredicate(format: "%K CONTAINS[cd] %@",NoteProperties.title , searchTerm as CVarArg)
        let request = Note.fetch(predicate)

        let retrievedNotes = try! context.fetch(request)

        XCTAssertTrue(retrievedNotes.count == 1)
        XCTAssertTrue(retrievedNotes.contains(note1))
        XCTAssertFalse(retrievedNotes.contains(note2))
    }

    func test_search_term_in_title_or_bodytext() {

        let note1 = Note(title: "Dummy", context: context)
        note1.formattedBodyText = NSAttributedString(string: "test")
        let note2 = Note(title: "test more", context: context)

        let searchTerm = "test"

        let predicates = [NSPredicate(format: "%K CONTAINS[cd] %@", NoteProperties.title, searchTerm as CVarArg),
                          NSPredicate(format: "%K CONTAINS[cd] %@", NoteProperties.bodyText , searchTerm as CVarArg)]


        let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)

        let request = Note.fetch(predicate)
        let retrievedNotes = try! context.fetch(request)

        XCTAssertTrue(retrievedNotes.count == 2)
        XCTAssertTrue(retrievedNotes.contains(note1))
        XCTAssertTrue(retrievedNotes.contains(note2))
    }

    func test_search_multi_term_notes() {
        let note1 = Note(title: "Hello and World", context: context)
        let note2 = Note(title: "test more world", context: context)

        let searchTerms = ["Hello", "World", "and"]

        var predicates = [NSPredicate]()
        for term in searchTerms {
            predicates.append(NSPredicate(format: "%K CONTAINS[cd] %@", NoteProperties.title, term as CVarArg))
        }

        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        let request = Note.fetch(predicate)
        let retrievedNotes = try! context.fetch(request)

        XCTAssertTrue(retrievedNotes.count == 1)
        XCTAssertTrue(retrievedNotes.contains(note1))
        XCTAssertFalse(retrievedNotes.contains(note2))
    }

    func test_filter_by_notes_status_default_draft() {
        let note1 = Note(title: "Hello and World", context: context)
        let note2 = Note(title: "test more world", context: context)
        let note3 = Note(title: "note 3", context: context)

        let filterStatus = Status.draft

        let predicate = NSPredicate(format: "%K == %@", NoteProperties.status, filterStatus.rawValue as CVarArg)
        let request = Note.fetch(predicate)
        let retrievedNotes = try! context.fetch(request)

        XCTAssertTrue(retrievedNotes.count == 3)
        XCTAssertTrue(retrievedNotes.contains(note1))
        XCTAssertTrue(retrievedNotes.contains(note2))
        XCTAssertTrue(retrievedNotes.contains(note3))
    }

    func test_filter_by_notes_status_archived() {
        let note1 = Note(title: "Hello and World", context: context)
        let note2 = Note(title: "test more world", context: context)
        let note3 = Note(title: "note 3", context: context)
        note3.status = .archived

        let filterStatus = Status.archived

        let predicate = NSPredicate(format: "%K == %@", NoteProperties.status, filterStatus.rawValue as CVarArg)
        let request = Note.fetch(predicate)
        let retrievedNotes = try! context.fetch(request)

        XCTAssertTrue(retrievedNotes.count == 1)
        XCTAssertFalse(retrievedNotes.contains(note1))
        XCTAssertFalse(retrievedNotes.contains(note2))
        XCTAssertTrue(retrievedNotes.contains(note3))
    }

    func test_search_for_favorite_notes() {
        let note1 = Note(title: "Hello and World", context: context)
        let note2 = Note(title: "test more world", context: context)
        note2.isFavorite = true

        let predicate = NSPredicate(format: "isFavorite == true")

        let request = Note.fetch(predicate)
        let retrievedNotes = try! context.fetch(request)

        XCTAssertTrue(retrievedNotes.count == 1)
        XCTAssertFalse(retrievedNotes.contains(note1))
        XCTAssertTrue(retrievedNotes.contains(note2))
    }
//
    func test_fetch_notes_for_last_7_days() {
        let calendar = Calendar.current

        let beginDate = calendar.date(byAdding: .day, value: -7, to: Date())!

        let note1 = Note(title: "Hello and World", context: context)
        note1.creationDate_ = calendar.date(byAdding: .day, value: -2, to: Date())
        let note2 = Note(title: "test more world", context: context)
        note2.creationDate_ = calendar.date(byAdding: .day, value: -9, to: Date())

        let predicate = NSPredicate(format: "%K < %@", NoteProperties.creationDate, beginDate as NSDate)

        let request = Note.fetch(predicate)
        let retrievedNotes = try! context.fetch(request)

        XCTAssertTrue(retrievedNotes.count == 1)
        XCTAssertFalse(retrievedNotes.contains(note1))
        XCTAssertTrue(retrievedNotes.contains(note2))
    }

    func test_fetch_notes_of_last_week() {
        let calendar = Calendar.current

        let today = Date(timeIntervalSince1970: 1670502427)
        print("today \(today.description(with: Locale(identifier: "ENG")))")

        for index in 0..<7 {
            let note = Note(title: "", context: context)
            note.creationDate_ = calendar.date(byAdding: .day, value: -index, to: today)
            print("notes days \(note.creationDate.description(with: Locale(identifier: "ENG")))")
        }

        let startOfWeek = calendar.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: today).date!
        let endDate = calendar.date(byAdding: .day, value: 1, to: startOfWeek)!

        print("startOfWeek \(endDate.description(with: Locale(identifier: "ENG")))")

        let beginDate = calendar.date(byAdding: .day, value: -7, to: endDate)!

        let predicate = NSPredicate(format: "creationDate_ > %@ AND creationDate_ <= %@",
                                    argumentArray: [beginDate, endDate])

        let request = Note.fetch(predicate)
        let retrievedNotes = try! context.fetch(request)

        XCTAssertTrue(retrievedNotes.count == 3)

    }
//
//    func test_search_notes_for_folder() {
//        let note1 = Note(title: "note", context: context)
//        let folder = Folder(name: "folder", context: context)
//        folder.notes.insert(note1)
//
//        let predicate = NSPredicate(format: "%K == %@", NoteProperties.folder, folder)
//
//        let request = Note.fetch(predicate)
//        let retrievedNotes = try! context.fetch(request)
//
//        XCTAssertTrue(retrievedNotes.count == 1)
//        XCTAssertTrue(retrievedNotes.contains(note1))
//    }
//
//    func test_search_notes_with_keyword() {
//        let keyword = Keyword(context: context)
//        let note1 = Note(title: "dd", context: context)
//        note1.keywords.insert(keyword)
//        _ = Note(title: "note 2", context: context)
//        _ = Note(title: "note 3", context: context)
//
//        let predicate = NSPredicate(format: "%K CONTAINS %@", NoteProperties.keywords, keyword)
//
//        let request = Note.fetch(predicate)
//        let retrievedNotes = try! context.fetch(request)
//
//        XCTAssertTrue(retrievedNotes.count == 1)
//        XCTAssertTrue(retrievedNotes.contains(note1))
//    }
//
//    func test_search_notes_for_multiple_keywords() {
//        let keyword1 = Keyword(context: context)
//        let keyword2 = Keyword(context: context)
//
//        let note1 = Note(title: "dd", context: context)
//        note1.keywords.insert(keyword1)
//        let note2 = Note(title: "note 2", context: context)
//        let note3 = Note(title: "note 3", context: context)
//        keyword2.notes.insert(note3)
//
//        var selectedKeywords = Set<Keyword>()
//        selectedKeywords.insert(keyword2)
//        selectedKeywords.insert(keyword1)
//
//        let predicate = NSPredicate(format: "ANY %K in %@", NoteProperties.keywords, selectedKeywords)
//
//        let request = Note.fetch(predicate)
//        let retrievedNotes = try! context.fetch(request)
//
//        XCTAssertTrue(retrievedNotes.count == 2)
//        XCTAssertTrue(retrievedNotes.contains(note1))
//        XCTAssertTrue(retrievedNotes.contains(note3))
//    }
//
//    func test_search_notes_without_selected_keywords() {
//        let keyword1 = Keyword(context: context)
//        let keyword2 = Keyword(context: context)
//
//        let note1 = Note(title: "dd", context: context)
//        note1.keywords.insert(keyword1)
//        let note2 = Note(title: "note 2", context: context)
//        let note3 = Note(title: "note 3", context: context)
//        keyword2.notes.insert(note3)
//
//        var selectedKeywords = Set<Keyword>()
//        selectedKeywords.insert(keyword2)
//        selectedKeywords.insert(keyword1)
//
//        let predicate = NSPredicate(format: "NONE %K in %@", NoteProperties.keywords, selectedKeywords)
//
//        let request = Note.fetch(predicate)
//        let retrievedNotes = try! context.fetch(request)
//
//        XCTAssertTrue(retrievedNotes.count == 1)
//        XCTAssertTrue(retrievedNotes.contains(note2))
//    }
//
//    func test_search_notes_with_no_keywords() {
//        let keyword1 = Keyword(context: context)
//        let keyword2 = Keyword(context: context)
//
//        let note1 = Note(title: "dd", context: context)
//        note1.keywords.insert(keyword1)
//        let note2 = Note(title: "note 2", context: context)
//        let note3 = Note(title: "note 3", context: context)
//        keyword2.notes.insert(note3)
//
//        let predicate = NSPredicate(format: "keywords_.@count == 0")
//
//        let request = Note.fetch(predicate)
//        let retrievedNotes = try! context.fetch(request)
//
//        XCTAssertTrue(retrievedNotes.count == 1)
//        XCTAssertTrue(retrievedNotes.contains(note2))
//    }
}

