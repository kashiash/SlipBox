//
//  NoteListView.swift
//  SlipBox
//
//  Created by Jacek Kosinski U on 03/09/2023.
//

import SwiftUI
import CoreData

struct NoteListView: View {

    @ObservedObject var selectedFolder: Folder
    @Binding var selectedNote: Note?

    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        List (selection: $selectedNote){
            ForEach(selectedFolder.notes.sorted()) { note in
                NavigationLink(value: note) {
                    NoteRow(note: note)
                }
            }
            .onDelete(perform: deleteItems)
        }
        .toolbar {
            ToolbarItem {
                Button(action: addNote) {
                    Label("Add Item", systemImage: "note.text.badge.plus")
                }
            }
        }
    }

    private func addNote() {
        let newNote = Note(title: "new note", context: viewContext)
        newNote.folder = selectedFolder
        selectedNote = newNote
    }

    private func deleteItems(offsets: IndexSet) {
        offsets.map { selectedFolder.notes.sorted()[$0]
        }.forEach(viewContext.delete)
    }
}

struct NoteListView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let folder = Folder(name: "new", context: context)


        NoteListView(selectedFolder: folder, selectedNote: .constant(nil)).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
