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

    @State private var columnVisibility: NavigationSplitViewVisibility = .all

    @State private var selectedFolder: Folder? = nil
    @State private var selectedNote: Note? = nil

    var body: some View {

        NavigationSplitView(columnVisibility: $columnVisibility) {
            FolderListView(selectedFolder: $selectedFolder)
        } content: {
            if let folder = selectedFolder {
                NoteListView(selectedFolder: folder,
                             selectedNote: $selectedNote)
            } else {
                Text("select a folder")
                    .foregroundColor(.secondary)
            }


        } detail: {
            if let note = selectedNote {
                NoteDetailView(note: note)
            }
            else {
                Text("select a note")
                    .foregroundColor(.secondary)
            }
        }
    }

}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
