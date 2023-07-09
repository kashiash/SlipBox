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


        VStack(spacing: 20){
            Text("Order \(Int(note.order))")

            TextField("title", text: $note.title)
                .textFieldStyle(.roundedBorder)
            Picker(selection: $note.status) {
                ForEach(Status.allCases){ status in
                    Text(status.rawValue)
                        .tag(status)
                }
            } label: {
                Text("Note's status")
            }
            .pickerStyle(.segmented)
            TextViewIOSWrapper(note: note)
        }
        .padding()
        .onDisappear {
            PersistenceController.shared.save()
        }

    }
}

struct NoteDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let note = Note(title: "New note ", context: context)
        NoteDetailView(note: note)
            .environment(\.managedObjectContext, context)
    }
}
