//
//  FolderListView.swift
//  SlipBox
//
//  Created by Jacek Kosinski U on 30/08/2023.
//

import SwiftUI

struct FolderListView: View {

    @Environment(\.managedObjectContext) var context
    @FetchRequest(fetchRequest: Folder.fetchTopFolders()) private var folders: FetchedResults<Folder>

    @Binding var selectedFolder: Folder?

    var body: some View {
        Group{


            List(selection: $selectedFolder) {
                ForEach(folders) { folder in
                        RecursiveFolderView(folder: folder)
                }
                .onDelete(perform: deleteFolders(offsets:))

            }}
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

        let context = PersistenceController.createEmptyStore().container.viewContext

        let nestedFolder = Folder.nestedFolderExample(context: context)
        _ = Folder(name: "Second folder", context: context)
       return  NavigationView{
            FolderListView(selectedFolder: .constant(nestedFolder))
                .environment(\.managedObjectContext, context)
        }
    }
}
