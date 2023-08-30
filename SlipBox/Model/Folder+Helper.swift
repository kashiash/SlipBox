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
        request.predicate = predicate
        return request
    }

    static func delete(_ folder: Folder) {
        guard let context = folder.managedObjectContext else { return }
        context.delete(folder)
    }
}
