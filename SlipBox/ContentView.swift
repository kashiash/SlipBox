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

    @State private var selectedNote: Note? = nil
    @State private var selectedFolder : Folder? = nil
    @State private var columnVisiblity: NavigationSplitViewVisibility = .all

    
    var body: some View {
        NavigationSplitView (columnVisibility: $columnVisiblity){
            FolderListView(selectedFolder: $selectedFolder)
        } content: {
            if let folder = selectedFolder {
                NoteListView(selectedFolder: folder, selectedNote: $selectedNote)
            }
        } detail: {
            if let note = selectedNote {
                NoteDetailView(note: note)
            } else {
                Text("Select a note")
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
