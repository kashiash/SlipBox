//
//  Persistence.swift
//  SlipBox
//
//  Created by Jacek Kosinski U on 22/06/2023.
//

import CoreData
import Combine
import CloudKit

class PersistenceController : ObservableObject {
    static let shared = PersistenceController()

    let container: NSPersistentCloudKitContainer
    var subscriptions = Set<AnyCancellable>()

    @Published var syncErrorMessage: String? = nil

    init(inMemory: Bool = false) {

        container = NSPersistentCloudKitContainer(name: "SlipBox")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        } else {
            #if DEBUG
            setupSchemaSync()
            #endif
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        checkSyncStatus()
    }
    func setupSchemaSync() {
        let options = NSPersistentCloudKitContainerSchemaInitializationOptions()
        do {
            try container.initializeCloudKitSchema(options: options)
        } catch {
            print("cloudkit sync - schema error: \(error)")
        }
    }
    func checkSyncStatus() {
        NotificationCenter.default.publisher(for: NSPersistentCloudKitContainer.eventChangedNotification)
            .sink { notification in
            guard let event = notification.userInfo?[NSPersistentCloudKitContainer.eventNotificationUserInfoKey] as?
                    NSPersistentCloudKitContainer.Event else { return }
                if event.endDate == nil {
                    print("cludkit event start")
                } else {
                    switch event.type {
                    case .setup: print("cloudkit event - setup finished")
                    case .import: print("cloudkit event - import finished")
                    case .export: print("cloudkit event - export finished")
                    @unknown default:
                       print("cloud kit event - add new type")
                    }
                    if event.succeeded {
                        print("cloudkit event - succesed")
                    } else {
                        print("cloudkit event - not succesed")
                    }
                    if let error = event.error as? CKError {
                        print("cloudkit event - error \(error.localizedDescription)")
                        switch error.code {
                        case .quotaExceeded:
                            self.syncErrorMessage  = "quota exceeded, please free up some space on iCloud"
                           // print("quota exceeded, please free up some space on iCloud")
                        @unknown default:
                            print("Ask chat gpt what happens")
                        }
                    }
                }

        }
        .store(in: &subscriptions)
    }

    func save() {
        let context = container.viewContext
        guard context.hasChanges else {return}
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    //MARK: SwiftUI preview helper
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for index in 0..<10 {
            let newNote = Note(title: "new note \(index)",context: viewContext)
            newNote.creationDate_ = Date() + TimeInterval(index)

            let newFolder = Folder(name: "folder \(index)", context: viewContext)
            newFolder.creationDate = Date() + TimeInterval(index)
        }
        return result
    }()

    static func createEmptyStore() -> PersistenceController {
        return PersistenceController(inMemory: true)
    }



}
