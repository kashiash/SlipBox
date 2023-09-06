//
//  Atachment+Helper.swift
//  SlipBox
//
//  Created by Jacek Kosinski U on 06/09/2023.
//

import Foundation
#if os (OSX)
import AppKit
#else
import UIKit
#endif
import CoreData

extension Attachment {

    convenience init(image: Data?, context: NSManagedObjectContext) {
        self.init(context: context)
        self.imageData = image
    }

    static func createThumbnail(from imageData: Data, thumbnailPixelSize: Int) -> UIImage? {

        let options = [kCGImageSourceCreateThumbnailWithTransform: true,
                    kCGImageSourceCreateThumbnailFromImageAlways : true,
                              kCGImageSourceThumbnailMaxPixelSize: thumbnailPixelSize] as CFDictionary

        guard let imageSource = CGImageSourceCreateWithData(imageData as CFData, nil),
              let imageReference = CGImageSourceCreateImageAtIndex(imageSource, 0, options) else {
            return nil
        }

#if os(iOS)
        return UIImage(cgImage: imageReference)
#else
        return UIImage(cgImage: imageReference, size: .zero)
#endif
    }

    func getThumbnail() -> UIImage? {
        guard thumbnailData == nil else {
            return UIImage(data: thumbnailData!)
        }

        guard let imageData = imageData else {
            return nil
        }

        let newThumbnail = Attachment.createThumbnail(from: imageData, thumbnailPixelSize: 200)


#if os(iOS)
        self.thumbnailData = newThumbnail?.pngData()
#else
        self.thumbnailData = newThumbnail?.tiffRepresentation
#endif

        return newThumbnail
    }
}
