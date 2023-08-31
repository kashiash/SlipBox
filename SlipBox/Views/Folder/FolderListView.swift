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

    @State private var selectedFolder: Folder? = nil

    var body: some View {
        List(selection: $selectedFolder) {
            ForEach(folders) { folder in
                Text(folder.name)
                    .tag(folder)
            }
        }
        // .listStyle(.plain)
        .toolbar {
            ToolbarItem (placement: .primaryAction)  {
                Button {
                    let newFolder = Folder(name: "new folder", context: context)
                    selectedFolder = newFolder

                } label: {
                    Label("Create new folder", systemImage: "folder.badge.plus")
                }
            }
        }
    }
}

struct FolderListView_Previews: PreviewProvider {
    static var previews: some View {
        FolderListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
