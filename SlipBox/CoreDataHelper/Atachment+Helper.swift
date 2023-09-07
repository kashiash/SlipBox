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

    static let maxThumbnailPixelSize: Int = 600

    convenience init(image: Data?, context: NSManagedObjectContext) {
        self.init(context: context)
        self.imageData = image
    }

    static func createThumbnail(from imageData: Data,
                                thumbnailPixelSize: Int) -> UIImage? {
        let options = [kCGImageSourceCreateThumbnailWithTransform: true,
                       kCGImageSourceCreateThumbnailFromImageAlways: true,
                       kCGImageSourceThumbnailMaxPixelSize: thumbnailPixelSize] as CFDictionary

        guard let imageSource = CGImageSourceCreateWithData(imageData as CFData, nil),
              let imageReference = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options) else {
            return nil
        }

        #if os(iOS)
        return UIImage(cgImage: imageReference)
        #else
        return UIImage(cgImage: imageReference, size: .zero)
        #endif
    }

    func getThumbnail() async -> UIImage? {

        guard thumbnailData == nil else {
            let image = await Attachment.createImage(from: thumbnailData!)
            return image
        }

        guard let fullImageData = imageData else {
            return nil
        }

        let newThumbnail = await Task {
            Attachment.createThumbnail(from: fullImageData,
                                       thumbnailPixelSize: Attachment.maxThumbnailPixelSize)
        }.value


        Task {
        #if os(iOS)
        self.thumbnailData = newThumbnail?.pngData()
        #else
        self.thumbnailData = newThumbnail?.tiffRepresentation
        #endif
        }

        return newThumbnail
    }

    static func createImage(from imageData: Data) async -> UIImage? {
        let image = await Task(priority: .background) {
            UIImage(data: imageData)
        }.value

        return image
    }

    func createFullImage() async -> UIImage? {
        guard let data = imageData else { return nil }
        let image = await Attachment.createImage(from: data)
        return image
    }

    func updateImageSize(to newSize: CGSize?) {
        if let newHeight = newSize?.height,
            height != Float(newHeight) {
            height = Float(newHeight)
        }

        if let newWidth = newSize?.width,
           width != Float(newWidth) {
            width = Float(newWidth)
        }
    }

    func imageWidth() -> CGFloat {
        if width > 0 {
            return CGFloat(width)
        } else {
            return CGFloat(Attachment.maxThumbnailPixelSize)
        }
    }

    func imageHeight() -> CGFloat {
        if height > 0 {
            return CGFloat(height)
        } else {
            return CGFloat(Attachment.maxThumbnailPixelSize)
        }
    }
}
