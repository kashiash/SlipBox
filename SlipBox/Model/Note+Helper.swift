//
//  Note+Helper.swift
//  SlipBox
//
//  Created by Jacek Kosinski U on 25/06/2023.
//

import Foundation
import CoreData

extension Note {

    convenience init (title: String, context:NSManagedObjectContext) {
        self.init(context: context)
        self.title = title

        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    public override func awakeFromInsert() {
        self.creationDate = Date()
    }
}
