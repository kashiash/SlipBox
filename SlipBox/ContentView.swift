//
//  ContentView.swift
//  SlipBox
//
//  Created by Jacek Kosinski U on 22/06/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(fetchRequest: Note.fetch(.all))

//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Note.creationDate, ascending: true)],
//        animation: .default)
    
    private var notes: FetchedResults<Note>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(notes) { note in
                    NavigationLink {
                        NoteDetailView(note: note)
                    } label: {
                        VStack{
                            Text(note.title)
                            Text(note.creationDate!, formatter: itemFormatter)
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem {
                    Button(action: addNote) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            
        }
    }
    
    private func addNote() {
        let newNote = Note(title: "new note", context: viewContext)
    }
    
    private func deleteItems(offsets: IndexSet) {
        offsets.map { notes[$0] }.forEach(viewContext.delete)
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
