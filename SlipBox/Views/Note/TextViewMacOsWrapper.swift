//
//  TextViewMacOsWrapper.swift
//  SlipBox
//
//  Created by Jacek Kosinski U on 09/07/2023.
//

import SwiftUI

struct TextViewMacOsWrapper: NSViewRepresentable {
    let note: Note

    func makeCoordinator() -> Coordinator {
        Coordinator(note: note, parent: self)
    }

    func makeNSView(context: Context) -> some NSTextView {
        let view = NSTextView()

        view.isRichText = true
        view.isEditable = true
        view.isSelectable = true
        view.allowsUndo = true
        view.allowsImageEditing = true

        view.usesInspectorBar = true

        view.usesFindPanel = true
        view.usesFindBar = true
        view.isGrammarCheckingEnabled = true
        view.isRulerVisible = true


        view.delegate = context.coordinator
        return view
    }
    func updateNSView(_ nsView: NSViewType, context: Context) {
        nsView.textStorage?.setAttributedString(note.formattedBodyText)
        context.coordinator.note = note
    }
    class Coordinator: NSObject, NSTextViewDelegate {
        var note: Note
        let parent: TextViewMacOsWrapper

        init(note: Note, parent: TextViewMacOsWrapper) {
            self.note = note
            self.parent = parent
        }

        func textDidChange(_ notification: Notification) {
            if let textview = notification.object as? NSTextView {
                note.formattedBodyText = textview.attributedString()
            }
        }
    }

}

struct TextViewMacOsWrapper_Previews: PreviewProvider {
    static var previews: some View {
        TextViewMacOsWrapper(note: Note(title: "new note",context: PersistenceController.preview.container.viewContext))
    }
}
