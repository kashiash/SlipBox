//
//  Folder+Helper.swift
//  SlipBox
//
//  Created by Jacek Kosinski U on 28/08/2023.
//

import Foundation
import CoreData

extension Folder {

    var name : String {
        get { name_ ?? "" }
        set { name_ = newValue }
    }

    var creationDate: Date {
        get {creationDate_ ?? Date()}
        set {creationDate_ = newValue}
    }

    var subfolders: Set<Folder> {
        get {(subfolders_ as? Set<Folder>) ?? []}
        set {subfolders_ = newValue as NSSet }
    }

    var notes: Set<Note> {
        get { (notes_ as? Set<Note>) ?? []}
        set {notes_ = newValue as NSSet }
    }

    convenience init(name: String , context: NSManagedObjectContext)  {
        self.init(context: context)
        self.name = name
    }
    public override func awakeFromInsert() {
        self.creationDate_ = Date()
    }

    static func fetch(_ predicate: NSPredicate) -> NSFetchRequest<Folder> {
        let request = Folder.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Folder.creationDate_, ascending: true)]
        request.fetchBatchSize = 5
        request.predicate = predicate
        return request
    }

    static func fetchTopFolders() -> NSFetchRequest<Folder> {
        let predicate = NSPredicate(format: "%K == nil", FolderProperties.parent)
        return Folder.fetch(predicate)
    }

    static func delete(_ folder: Folder) {
        guard let context = folder.managedObjectContext else { return }
        context.delete(folder)
    }


    static func nestedFolderExample(context: NSManagedObjectContext) -> Folder {
        let parent = Folder(name: "parent", context: context)
        let child1 = Folder(name: "child1", context: context)
        parent.subfolders.insert(child1)
        let child2 = Folder(name: "child2", context: context)
        parent.subfolders.insert(child2)
        let child1_2 = Folder(name: "child1_2", context: context)
        child1.subfolders.insert(child1_2)
        let child1_1 = Folder(name: "child1_1", context: context)
        child1.subfolders.insert(child1_1)
        let child1_2_1 = Folder(name: "child1_2_1", context: context)
        child1_2.subfolders.insert(child1_2_1)

        return parent
    }
}

extension Folder: Comparable {
    public static func < (lhs: Folder, rhs: Folder) -> Bool {
        lhs.creationDate < rhs.creationDate
    }


}

//MARK: - define my string constants

struct FolderProperties {
    static let parent = "parent"
    static let children = "children_"
    static let name = "name_"
}

