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
            Text("Note detail view").font(.title)
            HStack {
                Text("Title:")
                Text(note.title)
            }

            Picker(selection: $note.status) {
                ForEach(Status.allCases){ status in
                    Text(status.rawValue)
                        .tag(status)
                }
            } label: {
                Text("Note's status")
            }
            .pickerStyle(.segmented)

            Button("Clean the tile") {
                note.title = ""
            }

            TextField("title", text: $note.title)
                .textFieldStyle(.roundedBorder)
            Button("Delete Note"){
                let context = note.managedObjectContext
                context?.delete(note)
            }
            .foregroundColor(.pink)
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
