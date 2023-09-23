## NOTE ATACHMENT





And the time it processes depends strongly on how large your images are. This one is quite small. If you use an image that I here generated which is like 18 megabytes, I know this is extreme, but that's the whole point. You see, nothing happens. Actually, I can't interact with my interface because the UI is blocked. Then this image is loaded and attached to the database. I'm just going to add another one. So there is a small lag. And if I use now the large image again, and in the meantime I try to type here, nothing happens. Then as soon as this image is coming, the main UI is freed up again, and I can continue here typing, or it updates the UI actually with my typing. In this case, the problem is every time I want to show this, I need to load it from the database, create a UI image from the data. This can be quite heavy work. In this case I waited but for example if I go to the small image and then to a node with large image First of all I didn't clear it so we also need to do this And it takes a couple of seconds until this image is coming. So every time I switch it between my nodes I need to... it's loading again this huge images. This one huge image So you see it's taking quite a long time and in the meantime I can't really do anything. This is not a good behavior In order to fix this we can do two things. First, I can load this image in the background to not block my main UI. And for this I'm going to use a task, Async/Await. This is just because it works better with the way I set up my project. Because I just want to run a function in the background that is connected to a view. So this task modifier makes more sense you could do this also with combine create a new view model and set this up there. I'm going to use async await and the second thing we can do to improve the performance is create actually a thumbnail a much smaller version of our full blown image. So we need to create compressed version of our image which I again want to do in the background to not block my main UI and And then we have to ask ourselves, do I want to store this in the database, this thumbnail? Would I prefer to have this just cached? So it only creates them in demand. And then when I go back and forth here, it's much, much faster to switch between these nodes to get the correct update of this image. So we're going to create a thumbnail attribute that is derived, so that is not stored in the database. which means that every time I launch my application again, these thumbnails are not there anymore and you need to regenerate them. But once we generate them one time, during the one run of our application, we can reuse them again. For this, we also need to talk about processing in the background for data that belongs to our database in the core data context. We need to check how to process things accordingly when I show this. So the final thing that I want to have is here in this view, I want to have, when I change this photo, I'm going to update my full image property. When I have this and I show my node view here, I need to generate a thumbnail in the background. So this is actually the thumbnail, which makes it much faster to load this views. And then when I double tap on this thumbnail, I'm going to have a pop-up or a sheet showing the full-blown image. But because it's a big image, it also takes time to load it, as you just saw here. So we also do it on the background, so people can stop in between if they don't want to see it. I'm going to create a separate attachment entity. So we have a relationship on each of these nodes can have one attachment. And each attachment belongs to one node, so it's a one-to-one relationship. it's nice because it helps me with the, in some cases, just separating it out. When there is large data involved, it gives you some performance things because you don't always, in order to know if there's an image, you don't need to load the image. You can just check if there's an attachment, if there's a link attached. And the other advantage of separating it in this entity is to have a couple of properties, attributes that belong together. because if I delete my attachment which includes the thumbnail and the image in this case, then I always delete everything together. So it's a nice separate way of our data. If you want to have more than one image, you would also have to create a relationship to a separate attachment entity because then you can, every time you want to have an array of things, you have to create a entity and then a relationship with too many. I'm going to start these changes by modifying my schema. First I'm creating a new entity which is the attachment and I need two properties. This was the full image of type binary data and the other one is a thumbnail which is again a binary data and this one I want to make transient to not store it permanently in my database. I can also check here allow external storage, which is even more important for my large scale image. This is not transient. This is the one that is persistent in my database. To make it a little bit clearer from the naming, I'm going to use your thumbnail data and full image data. Because of this async background tasks, I'm not relying so much on this computed properties. I'm creating async functions that create me an image from the data in the database. Then, the main part of this attachment is the relationship to node. So this is the node, destination node. Then, I'm using the nullify rule because when I delete the attachment, I don't delete the node, I just remove the link to one. Each attachment belongs to one node. We do then the opposite in my nodes. I add a new relationship "attachment" to "attachment" and the inverse is "node". Here I'm going to use "toNode" just to separate this out. The delete rule is cascade, so if I delete the node, I want to also delete the attachment. This is the replacement of my previous image attribute. I'm not deleting this now because otherwise my app is going to complain everywhere. I will do this later and then we check where to replace this. Okay, now that I have here my properties, I want to just add the code for creating this thumbnail, which belongs to the attachment. So I'm creating the extension of the attachment. So it's a new Swift file, attachment plus helper, which is an extension to attachment. What I want to have is a function that creates a thumbnail. I'm going to add this static function on the class, static function create thumbnail from image data, which is a data. And then we need to give how much we want to shrink this down. So we want to give the thumbnail pixel size, which is an int. And I'm returning here a UI image, optional, because we might not be able to, this data might be something and we don't know if we can generate an image from it. I'm going to use CG image because they have already existing functions which create thumbnails, that's because it is a typical task to do in an application. So you can just copy the code. So this is options where we have to give some options for the CG image conversion. ACG image source create, create thumbnail with transform. Yes, this is true. So this is a dictionary. Actually, they all start with CG. Yes, we don't have this in scope because I only have foundation. So depending on what you run, you need to know include a packet or UI kit. So hashtag if I OS is OS X for macOS hashtag else import UI kit hashtag and F. Okay, now Now it finds it. So all of these options start with KCG image source, create thumbnail from image always, true, and KCG image source thumbnail maximum pixel size. So here we can actually give the, in this case, the entry in the dictionary is the thumbnail pixel size here. And I cannot, now it complains about the type. So I can typecast this as a CF dictionary. Now I have the options and we create the image source, which is a CG image source create with data. And here we can give the data and in this case these options are just nil. Now I have to call a function to create the actual thumbnail data. So this is image reference, which is the CG image. Source create thumbnail at index, where we give the image source that I just created. The index I don't care and the options, this is the options that we just set. And now this is, and it's complaining here with the data, so this is SCF data. This is returning an optional, so I use a guard, guard else return nil. And now I can return a UI image from CG image with image and size. These are different for macOS and iOS. So if you don't specify a size or just zero, it uses the intrinsic size. And this complains again. So we can add the because of the optional. So I'm adding this here to my guard statement. These UI image initializers are different for macros and iOS. I'm going to switch to iOS build target. Okay, you can run to get the error and here it says we don't have this. So we can use the #if, #ios, #endif, #else and #endif. So in case I'm on iOS, I return a UI image from CG image with this image reference. 

```swift
static func createThumbnqail(from imageData: Data, thumbnailPixelSize: Int) -> UIImage? {
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
```



This is the first part. Now when do I actually create here my thumbnail? When I want to access this image. So I'm going to write a function where we get the thumbnail. Part of the reasons why I have to write here a function is because it's a transient property.





```swift
    func getThumbnail() -> UIImage? {
        guard thumbnailData == nil else {
            return UIImage(data: thumbnailData!)
        }

        guard let imageData = imageData else {
            return nil
        }

        let newThumbnail = Attachment.createThumbnqail(from: imageData, thumbnailPixelSize: 200)
      self.t
        return newThumbnail
    }
```

Attachment thumbnail. I'm here in the extension of the attachment. So I have access directly to the thumbnail data. This is optional because maybe I didn't set it before. I'm using a guard statement to check if it is null, else I have something and I return here early birthday image by creating a UI image from this thumbnail data. Now I know it's not null, so I can force unwrap. Otherwise we need to continue because we don't have this transient property, this transient attribute from the data. So we need to first call this function to create a thumbnail from our main image data. So I need to check what is in my full image data. If I have something, then I can continue creating this. So guard let full image data is this one else return nil. So when would this happen that I don't actually have a full image? I usually create an attachment and directly set this full image here. You could also write an initializer for the attachment from image or from data. Usually you have an image, but there is a situation where you don't have an image yet and that can happen when you use the sync with iCloud, especially if this image is larger. Usually the attachment object arrives first and then the image is loaded afterwards. So there is a situation where you don't have this. Now, when I have my full image data, I need to call this function to create my new thumbnail. So this is, and the create thumbnail from my full image data. And now you can specify the pixel size. So you can set something like 200. This is returning a UI image and I can return this new thumbnail here. If I leave it like this, I actually never use the transient thumbnail data property. You can see this transient more as a cache, as a temporary store for your data. 



```swift
#if os(iOS)
        self.thumbnailData = newThumbnail?.pngData()
#else
        self.thumbnailData = newThumbnail?.tiffRepresentation
#endif
        return newThumbnail
```

So I need to actually put it there, which is my thumbnail data. I'm going to, I want to set this new thumbnail, which is a UI image and I actually want to have a data. Now I need to transform it back and you can use, for example, on iOS, we have PNG data that returns a data or a JPEG data with a compression quality. So this is actually compressing it further down. Usually it's smaller, but for ease of use, I'm just using here PNG. I'm just going to use PNG data because it's very small and I only temporarily, I only cache it anyway. If it's nil, then my thumbnail data in a store is nil. That's not a problem. This creating data from images is different from Mac OS. So I switch to my building for Mac OS and try to, yes, and it gives me an error because it doesn't have a PNG data. So again, I need to use here if, #ifOS is iOS, I use my PNG, #else, #endif. So in case I'm on Mac OS, my thumbnail data I'm getting from the new thumbnail has the TIFF representation. You can also use a TIFF compression where you can give here, this is a factor I think from 0 to 1. I think if you put 0 is no compression and 1 is maximum compression. Okay, we are not going to use this, but you could also do that further compression. This should be sufficient. It also helps with performance because if you compress further, you need to run an extra task for that. Now I can create a thumbnail for my full image and I can cache it temporarily in my database with this transient thumbnail data. 



(17:50) Next I actually want to change my UI, my user interface to use my new thumbnail, this attachment. So when I go to the node detail view, here, I have two situations that I have to change. One of them is when I import a new image or a new photo in the note photo selector button. This is the part where I import this and then in the task I load this new image as the data and I set it here to my nodes image. So this I don't want to use anymore. I want to now use the note attachment. I want to use here a new attachment from context, which means that I have to access the environment. I need to access the managed object context from the environment. Managed object context, var context, so that we can create here an attachment and then set the nodes attachment full image to this data. There is a small problem. This works when I import this fine, but if I change my image, I every time create a new attachment. And I also want to create here a convenience initializer for attachment where I directly set my full image data. So my attachment helper I create a convenience init with image data and you can also make this optional and then context and as managed object context, self.init from context and then start here self.image, just fold the image to this image. This nice convenience initializer makes this line, these two lines into one. So I can create a new image from the data with the context. But these creating new attachment I should only do if I not already have an attachment, if the node's attachment is nil. If I have an attachment in my node, I'm just changing the attachment's full image data to the data that I got from my photo picker. And else, if my attachment is nil, then I create a new one and I directly set the image data. The other thing here to consider is if I overwrite an existing image, I also need to overwrite the existing thumbnail. And I actually just want to set this to nil so that it reloads the new one. So the attachments, thumbnail data, I'm also setting here to nil. Otherwise it doesn't clear the cached thumbnail, the old one. Okay, now I have means to import this. And in this view that I need to change is just here when I set this import and photo for my picker. I now check the attachment. So if the node's attachment is null, then I check this here. Okay, now I am loading this image. And the next thing is I need to show this image. So in my node detail view, I have this optional image view. And this is now replaced by the attachments thumbnail data. And actually, I need to create here this thumbnail. So you could call the get thumbnail to get this UI image, because we need to check if it's loaded or not. And you already see that I need to do a little bit more. Instead of the optional image, I'm creating a different one where we can handle whole attachment stuff.

```swift
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
```



 So I create a new file which is SwiftUI view, attachment or node attachment view. This needs to have the attachment. I don't care about the other stuff because the attachment has the images. I don't need to have the full node. I am not using the preview because I need to do here this. It's a little bit more complicated to get the data from image and I don't have any preset. So I'm just uncommenting the preview. Or I can just delete it. So here I want to show my thumbnail, which means that I get the image from the function that we just checked, which is attachments, get thumbnail, returning an optional image. Now I can show image from UI image. Then I also want to show the full scale image and in order to show this I'm just using a double tap on my image on my thumbnail. Gesture with tap, gesture because then I can specify the count of two and then on End it, I can say here what I want to do. So I actually just want to show the full screen, which because it's UI, I need to have a state property that I can toggle. And state private var show full screen image or full scale image or full image. Pool, in the beginning, I don't want to do this, so I set the default to false. Now, when I double tap, I toggle this property and I need to add a sheet. You can also use a full screen. So I want to use here a sheet with this presenting where I can use the show full image. Okay, I need to now show here this image, which is in the attachments, the full image. So if let's data, if I have something, I can create an image from this. If let's image, this is a UI image. This is what we already did before from data, from this data and then show the image from this image. Because this is much larger, I'm going to make this resizable and scale to fit. This image is, I think I said 200 by 200, so it's quite small. Let's just attach this to my node detail view. Here, instead of this optional, I want to use the node attachment view, where I use the nodes attachment. And I'm only doing this if I have an attachment, so if that attachment is nodes attachment. The optional handling I have to do on the views because maybe you want to show a placeholder or something, so actually, there's always more button. 

```swift
            //OptionalImageView(data: note.attachment?.getThumbnail())
            if let attachment = note.attachment {
                NoteAttachmentView(attachment: attachment)
            }
            NotePhotoSelectorButton(note: note)
```

You can make this button more prominent or placeholder. So it's actually, I always want to know if it's there or not. of the time you want to know. So if I have an attachment I can show my node attachment view. I only have one attachment. If you have an array you would use a scroll view with horizontal scroll direction and then show them. So I'm in here, import an image and if I double tap it comes up. Okay maybe I should have added a close button because I want to toggle this off.