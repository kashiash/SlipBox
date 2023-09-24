//
//  FolderRow.swift
//  SlipBox
//
//  Created by Jacek Kosinski U on 31/08/2023.
//

import SwiftUI

struct FolderRow: View {
    @Environment(\.managedObjectContext) var viewContext
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
                    startRenameAction()
                }

                Button("Add subfolder"){
                    let subfolder = Folder(name: "new subsfolder", context: viewContext)
                    folder.subfolders.insert(subfolder)
                }

                Divider()

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

    func startRenameAction() {
        #if os(OSX)
        textFieldIsSelected = true
        #else
        showRenameEditor = true
        #endif
    }
}

struct FolderRow_Previews: PreviewProvider {
    static var previews: some View {
        FolderRow(folder: Folder(name: "new folder", context: PersistenceController.preview.container.viewContext))

            .frame(width: 200)
            .padding(50)
    }
}
