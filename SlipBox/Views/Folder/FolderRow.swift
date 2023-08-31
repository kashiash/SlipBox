//
//  FolderRow.swift
//  SlipBox
//
//  Created by Jacek Kosinski U on 31/08/2023.
//

import SwiftUI

struct FolderRow: View {

    @ObservedObject var folder: Folder

    @State private var showRenameEditor: Bool = false
    @State private var showDeleteConfirmation: Bool = false
    @FocusState private var textFieldIsSelected: Bool

    var body: some View {
        Group {
            #if os(iOS)
            Text(folder.name)
            #else
            TextField("name", text: $folder.name)
                .focused($textFieldIsSelected)

            #endif
        }
            .contextMenu {

                Button("Rename") {
                    #if os(OSX)
                    textFieldIsSelected = true
                    #else
                    showRenameEditor = true
                    #endif
                }

                Button("Delete") {
                   showDeleteConfirmation = true
                }
            }
            .confirmationDialog("Delete", isPresented: $showDeleteConfirmation) {
                Button("Delete") {
                    Folder.delete(folder)
                }
            }
            .sheet(isPresented: $showRenameEditor) {
                FolderEditorView(folder: folder)
            }
    }
}

struct FolderRow_Previews: PreviewProvider {
    static var previews: some View {
        FolderRow(folder: Folder(name: "new", context: PersistenceController.preview.container.viewContext))

            .frame(width: 200)
            .padding(50)
    }
}
