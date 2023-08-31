//
//  FolderListView.swift
//  SlipBox
//
//  Created by Jacek Kosinski U on 30/08/2023.
//

import SwiftUI

struct FolderListView: View {

    @Environment(\.managedObjectContext) var context
    @FetchRequest(fetchRequest: Folder.fetch(.all)) private var folders: FetchedResults<Folder>

    @Binding var selectedFolder: Folder?

    var body: some View {
        List(selection: $selectedFolder) {
            ForEach(folders) { folder in
                NavigationLink(value: folder) {
                    FolderRow(folder: folder)
                }
            }
            .onDelete(perform: deleteFolders(offsets:))

        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {

                    let newFolder = Folder(name: "new Folder", context: context)
                    selectedFolder = newFolder

                } label: {
                    Label("Create new folder", systemImage: "folder.badge.plus")
                }

            }
        }
    }
    private func deleteFolders(offsets: IndexSet) {
        offsets.map { folders[$0] }.forEach(Folder.delete(_:))
    }
}

struct FolderListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            FolderListView(selectedFolder: .constant(nil))
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
