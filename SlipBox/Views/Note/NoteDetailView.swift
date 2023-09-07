//
//  NoteDetailView.swift
//  SlipBox
//
//  Created by Jacek Kosinski U on 25/06/2023.
//

import SwiftUI

struct NoteDetailView: View {

    @ObservedObject var note: Note

    var body: some View {
        ScrollView{
            VStack(spacing: 20) {
                
                Text("order \(Int(note.order))")
                
                TextField("title", text: $note.title)
                    .textFieldStyle(.roundedBorder)
                    .font(.title)
                
                Picker(selection: $note.status) {
                    ForEach(Status.allCases) { status in
                        Text(status.rawValue)
                            .tag(status)
                    }
                } label: {
                    Text("Note´s status")
                }
                .pickerStyle(.segmented)
                
#if os(iOS)
                TextViewIOSWrapper(note: note)
#else
                
                TextViewMacOsWrapper(note: note)
#endif
                
                
                //OptionalImageView(data: note.img)
                if let attachment = note.attachment {
                    NoteAttachmentView(attachment: attachment)
                }
                
                NotePhotoSelectorButton(note: note)
                
            }
            
            .padding()
        }
      .onDisappear {
          PersistenceController.shared.save()
      }

    }
}

struct NoteDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let note = Note(title: "New note", context: context)

       return NoteDetailView(note: note)
            .environment(\.managedObjectContext, context)
    }
}
