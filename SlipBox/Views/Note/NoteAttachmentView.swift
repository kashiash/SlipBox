//
//  NoteAttachmentView.swift
//  SlipBox
//
//  Created by Jacek Kosinski U on 06/09/2023.
//

import SwiftUI

struct NoteAttachmentView: View {
    let attachment: Attachment
    @State private var showFullImage : Bool = false

    var body: some View {
        if let image = attachment.getThumbnail() {
            Image(uiImage: image)
                .gesture(TapGesture(count: 2).onEnded({ _ in
                    showFullImage.toggle()
                }))
                .sheet(isPresented: $showFullImage) {
                    if let data = attachment.imageData,
                       let image = UIImage(data: data) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                    }
                }
        }
    }
}


//struct NoteAttachmentView_Previews: PreviewProvider {
//    static var previews: some View {
//        NoteAttachmentView()
//    }
//}
