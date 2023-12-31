//
//  NotePhotoSelectorButton.swift
//  SlipBox
//
//  Created by Jacek Kosinski U on 11/07/2023.
//

import SwiftUI
import PhotosUI

struct NotePhotoSelectorButton: View {
    @Environment(\.managedObjectContext) var context
    @ObservedObject var note: Note
    @State private var selectedItem: PhotosPickerItem? = nil

    var body: some View {

        PhotosPicker(selection: $selectedItem,
                     matching: .images,
                     photoLibrary: .shared()) {
            if note.attachment == nil {
                Text("Import photo")
            } else {
                Text("Change photo")
            }
        }
        .onChange(of: selectedItem) { newValue in
                         Task{
                             do {
                                 if let data = try await newValue?.loadTransferable(type: Data.self) {
                                     update(data: data)
                                 }
                             } catch {
                                 print("Photopicker error: \(error.localizedDescription)")
                             }

                         }
                     }
    }

    @MainActor
    func update(data: Data){
        if let attachment = note.attachment {
            attachment.imageData = data
            attachment.thumbnailData = nil
        } else {
            note.attachment = Attachment(image: data, context: context)
        }
    }
}

struct NotePhotoSelectorButton_Previews: PreviewProvider {
    static var previews: some View {
        NotePhotoSelectorButton(note: Note(title: "new note",context: PersistenceController.preview.container.viewContext))
    }
}
