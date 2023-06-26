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
                    Text("Note detail view").font(.title)
                    HStack {
                        Text("Title:")
//                        Text(note.title ?? "no title")
                        Text(note.title)
                    }
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
