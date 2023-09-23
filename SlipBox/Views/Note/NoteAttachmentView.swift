//
//  NoteAttachmentView.swift
//  SlipBox
//
//  Created by Jacek Kosinski U on 06/09/2023.
//

import SwiftUI

import SwiftUI
import CoreData

struct NoteAttachmentView: View {

    @ObservedObject var attachment: Attachment

    @State private var showFullImage: Bool = false
    @State private var thumbnailImage: UIImage? = nil
    @State private var attachmentID: NSManagedObjectID? = nil

    @Environment(\.pixelLength) var pixelLength

    var body: some View {

        Group {
            if let image = thumbnailImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()

                    .gesture(TapGesture(count: 2).onEnded({ _ in
                        showFullImage.toggle()
                    }))

                    .sheet(isPresented: $showFullImage) {

                        FullImageView(attachment: attachment,
                                      title: "full image \(dataSize(data: attachment.imageData)) KB")
                    }
            } else {
                Color.gray
                    .frame(width: 200, height: 200)
            }
        }
        .frame(width: attachment.imageWidth() * pixelLength,
               height: attachment.imageHeight() * pixelLength)

        .task(id: attachment.imageData) {
            thumbnailImage = nil
            attachmentID = attachment.objectID

            let newThumbnailImage = await attachment.getThumbnail()

            attachment.updateImageSize(to: newThumbnailImage?.size)

            if self.attachmentID == attachment.objectID {
                thumbnailImage = newThumbnailImage
            }
        }
    }

    func dataSize(data: Data?) -> Int {
        if let data = data {
           return data.count / 1024
        } else {
           return 0
        }
    }

}


private struct FullImageView: View {

    let attachment: Attachment
    let title: String

    @State private var image: UIImage? = nil

    @Environment(\.dismiss) var dismiss


    var body: some View {

        VStack {

            HStack {
                Text(title)
                    .font(.title)
                Button("Done") {
                    dismiss()
                }
            }

            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView("Loading Image ...")
                    .frame(minWidth: 300, minHeight: 300)
            }
        }
        .padding()
        .task {
            image = await attachment.createFullImage()
        }
    }
}


//struct NoteAttachmentView_Previews: PreviewProvider {
//    static var previews: some View {
//        NoteAttachmentView()
//    }
//}
