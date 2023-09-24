//
//  RecursiveFolderView.swift
//  SlipBox
//
//  Created by Jacek Kosinski U on 23/09/2023.
//

import SwiftUI

struct RecursiveFolderView: View {

    @ObservedObject var folder: Folder
    @State private var showSubfolders = true

    var body: some View {

        HStack {
            Image(systemName: "folder")
            FolderRow(folder: folder)

            Spacer()

            if folder.subfolders.count > 0 {
                Button {
                    withAnimation {
                        showSubfolders.toggle()
                    }

                } label: {
                    Image(systemName: "chevron.right")
                        .rotationEffect(.init(degrees: showSubfolders ? 90 : 0))
                }
            } else {
                Color.clear
            }
        }
        .tag(folder)

        if showSubfolders {
            ForEach(folder.subfolders.sorted()) { subfolder in
                RecursiveFolderView(folder: subfolder)
                    .padding(.leading)
            }
            .onDelete(perform: deleteFolders(offsets:))
        }

    }

    private func deleteFolders(offsets: IndexSet) {
        offsets.map { folder.subfolders.sorted()[$0] }.forEach(Folder.delete(_:))
    }
}

struct RecursiveFolderView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            RecursiveFolderView(folder: Folder.nestedFolderExample(context: PersistenceController.preview.container.viewContext))

        }
    }
}
