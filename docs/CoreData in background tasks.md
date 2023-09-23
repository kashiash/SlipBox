# CoreData in background tasks



W niektórych przypadkach napotykałem problemy, ponieważ identyfikator obiektu nie był ustawiony, a także funkcje `insert` i `wakeFromInsert` nie były wywoływane. Co możemy tu poprawić, to to, że aktualizacje powinny odbywać się na głównym wątku lub na tzw głównym aktorze. Część obróbki załączników, które są na głównym kontekście,  powinna odbywać się na głównym aktorze. 

Dlatego muszę stworzyć osobną funkcję `updateData`, która potem wyrwał asynchronicznie. Parametrem jest  `Data` wybranego obrazka. Aby uruchomić to na głównym wątku, dodaję przed funkcją  `@MainActor`. 

```swift
    @MainActor
    func update(data: Data){

    }
```

Teraz mogę przenieść obecny kod ktory wpisuje obrazek do obiektu Attachment. W jego miejsce wsadzamy wywolanie nowej procedury, przy okazji warto użyć bloku `do catch`:



```swift
struct NotePhotoSelectorButton: View { 
  ...
  PhotosPicker(...) {...}
  .onChange(of: selectedItem) { newValue in
                               Task{
                                 do {
                                   if let data = try await 		       newValue?.loadTransferable(type: Data.self) {
                                     update(data: data)
                                   }
                                 } catch {
                                   print("Photopicker error: \(error.localizedDescription)")
                                 }
                               }
                              }
```

I tylko dla celów debugowania, pokazuję tutaj `localized description`. Może coś zostało przerwane w trakcie zadania lub obraz nie był we właściwym formacie. Ok, więc to jest opcjonalne. Jeśli więc, więc przenoszę to tutaj. 

kompletny kod po zmianach w `NotePhotoSelectorButton`

```swift
struct NotePhotoSelectorButton: View {
    @Environment(\.managedObjectContext) var context
    @ObservedObject var note: Note
    @State private var selectedItem: PhotosPickerItem? = nil

    var body: some View {

        PhotosPicker(selection: $selectedItem,
                     matching: .images,
                     photoLibrary: .shared()) {
            if note.attachment == nil {
                Text("Import photo")
            } else {
                Text("Change photo")
            }
        }
        .onChange(of: selectedItem) { newValue in
                         Task{
                             do {
                                 if let data = try await newValue?.loadTransferable(type: Data.self) {
                                     update(data: data)
                                 }
                             } catch {
                                 print("Photopicker error: \(error.localizedDescription)")
                             }

                         }
                     }
    }

    @MainActor
    func update(data: Data){
        if let attachment = note.attachment {
            attachment.imageData = data
            attachment.thumbnailData = nil
        } else {
            note.attachment = Attachment(image: data, context: context)
        }
    }
}
```





## Przetwarzanie obrazów w tle



Chcę teraz pokazać pełnoekranowe zdjęcie. Zrobiłem to. Chcę teraz dalej poprawić wydajność naszej aplikacji, ładować obrazy w tle. Na przykład, gdy mam miniaturę i chcę pokazać pełnoekranowe zdjęcie, wcześniej kliknąłem, aż to nakładka faktycznie się pojawiła. Teraz chciałbym, żeby po podwójnym kliknięciu od razu otworzyło się to okno i zobaczyłem wskaźnik aktywności. A jeśli nie chcę czekać, mogę nacisnąć "gotowe", a znowu się zamknie. Teraz zobaczmy, co zrobiłem, żeby pokazać to zdjęcie. Więc w moim widoku `NoteAttachmentView`, to jest widok, który pokazuje tę miniaturę. A gdy podwójnie kliknę, otwiera ona arkusz z moim pełnym obrazem. To jest widok, który zajmuje tyle czasu na ładowanie. Jedna rzecz, która tak naprawdę powoduje tę dużą ilość pracy, to kiedy tworzę obraz UI z tych danych, ponieważ moje obrazy są dość duże. Więc ten wywołanie chcę umieścić wosobnym wątku, i zamierzam użyć modyfikatora `Task` z SwiftUI, po prostu dlatego, że chcę uruchomić jedną funkcję, ten inicjalizator, który jest tutaj, na danych w tle, bez blokowania mojego głównego wątku. I inny aspekt to, że ten modyfikator `Task` jest związany z cyklem życia tego widoku. Co jest również wygodne, gdy wcisnę przycisk "gotowe" przed faktycznym pojawieniem się obrazu, po prostu się zatrzymuje. I żeby zobaczyć ten modyfikator, można go dołączyć do czegokolwiek. Więc tutaj, będę teraz tworzył mój obraz, ponieważ wszystko, co robisz w `body` - nazwijmy to tworzeniem czegoś, jest wykonywane na głównym wątku, więc możemy to zrobić. Muszę teraz tutaj, za pomocą modyfikatora `task`, stworzyć ten obraz, umieścić go w właściwości stanu i wyświetlić go tutaj ponownie. Więc potrzebuję właściwości stanu, `@State private var image`. To jest opcjonalny `UIImage`, nie, ponieważ nadal muszę go załadować, gdy przyjdzie. To wycinam i mówię, że jeśli jest obraz, to pokaż ten obraz UI tutaj. A w naszym zadaniu teraz muszę wykonać te dwie rzeczy. Muszę uzyskać pełne dane obrazu i muszę stworzyć ten obraz UI. Ponieważ przetwarzam coś, co należy do mojego załącznika, wszystkie te obrazy, a także tworzenie synchronicznego obrazu UI to coś, co mogę chcieć robić częściej. Umieszczę to w moim rozszerzeniu załącznika. Tylko dla przypomnienia, jest też `async image from URL`. To robi asynchroniczne pobieranie z URL, obraz, a potem tworzy widok obrazu z tego. Także wszystko robi również asynchronicznie. Niestety, `async image` nie ma inicjalizatora z danych, ponieważ to jest właściwie to, co robię, `async image from data`. Wracając do tworzenia obrazu UI z danymi za pomocą `task`, z `async/await`. I przechodzę do Attachment+Helper.swift. Tutaj na końcu możemy utworzyć inną funkcję. 



```swift
    static func createImage(from imageData: Data) async -> UIImage? {
        let image = await Task(priority: .background) {
            UIImage(data: imageData)
        }.value

        return image
    }
```

 Przyjmuje dane i chcę zwrócić opcjonalny obraz UI, ponieważ może się okazać, że nie mogę. Jeśli chcesz używać tego z modyfikatorem `task`, to musi być funkcją asynchroniczną, co muszę tutaj dodać za pomocą `async`.



Główna operacja, którą chciałem wykonać, to utworzenie obrazu UI na podstawie danych obrazu. Teraz ta operacja musi być wykonywana wewnątrz zadania. Możesz również określić priorytet. Na przykład, jeśli masz niski lub wysoki priorytet, możesz po prostu użyć tła (`background`). Następnie operacja tworzy ten obraz. Tak, to nie jest wartość zwracana, więc to po prostu mój obraz. I ponieważ jest to zadanie (`task`), to jest to jedna waga (weight). Jeśli wywołasz to, musisz poczekać na zakończenie zadania, aby uzyskać wartość tego zadania. To jest to, co zwracam tutaj, aby móc zwrócić ten obraz. Następnie mogę również utworzyć inną funkcję, ponieważ wiem, że to jest rozszerzenie mojego załącznika. Może więc dodamy funkcję do asynchronicznego tworzenia obrazu dla mojego pełnoekranowego obrazu. Więc to jest funkcja `func createFullImage`. Nie musi mieć żadnych argumentów. Ponownie jest to funkcja asynchroniczna. 

```swift
    func createFullImage() async -> UIImage? {
        guard let data = imageData else { return nil }
        let image = await Attachment.createImage(from: data)
        return image
    }
```

Zwraca obraz UI (UI image) opcjonalny. Najpierw sprawdzam dane, które stanowią moje pełnoekranowe dane obrazu, w przeciwnym razie zwracam tutaj "nil". Nie mam żadnego obrazu, który mógłbym wygenerować. Teraz chcę uzyskać ten obraz i wywołać tę funkcję. Więc to jest mój załącznik do tworzenia obrazu na podstawie tych danych, ponieważ jest to funkcja asynchroniczna. Muszę znowu poczekać na zakończenie wykonania tutaj. A potem mogę zwrócić ten obraz. Dobrze, teraz mam funkcję, którą mogę użyć w moim widoku pełnoekranowym obrazu. Więc w tym modyfikatorze `task` mogę wywołać na moim załączniku funkcję `createFullImage`, to jest wywołanie asynchroniczne. 



```swift
private struct FullImageView: View { 
        ...
				}
        .padding()
        .task {
            image = await attachment.createFullImage()
        }
```

A to jest obraz, który chcę ustawić na tym obrazie (`self.image`). I muszę poczekać. Gdy ten pełnoekranowy obraz jest wyświetlany, zadanie jest uruchamiane w celu wygenerowania tego obrazu. Jak tylko mam obraz, pokazuję tutaj obraz. Spróbujmy tego. 





Faktycznie muszę przejść do dużego obrazu. I myślę, że problem był tylko taki, że spowodowałem to - jest mały problem z moim układem. Sprobuję to pokazać. Problem polega na tym, że na początku nie ma go, więc nie jest przekazywana żadna przestrzeń na ten obraz. A potem ustawiam tutaj `resizable` i `scale to fit`. Więc jest to po prostu skalowane do dostępnej przestrzeni, która wynosi zero. Okej, w przeciwnym razie pokazuję tutaj widok postępu:

```swift
ProgressView("Loading Image ...").frame(minWidth: 300, minHeight: 300)
```

 co i tak jest dobrym pomysłem. Również z tytułem "Ładowanie obrazu", a następnie możesz dodać tutaj ramkę (`frame`) z minimalną szerokością 300 i minimalną wysokością 300.

```swift
private struct FullImageView: View {
			...
    var body: some View {
        VStack {
      ...
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
```

 Teraz, gdy podwójnie kliknę miniaturę, od razu otwiera mi się ta karta, co jest jeszcze bardziej zauważalne dla większego obrazu, a potem widzimy duży obraz, który można również powiększyć, korzystając z zadania (`task`) do ładowania tego dużego obrazu znacznie poprawiło doświadczenie (odczucia???) użytkownika, ponieważ od razu widzę, że coś się dzieje. Następna część, w której chcę właściwie użyć tego async/await, to generowanie moich miniatur.”



Obecnie nadal mamy akceptowalną wydajność, ale jeśli masz dużą ilość załączników, musisz je wszystkie utworzyć naraz i zablokujesz swoje główne UI znacznie bardziej. Spójrzmy teraz, jak przekształcić tworzenie tej miniaturki w funkcję async/await. W `AttachmentHelper.swift` kod do generowania tej miniaturki wygląda tak:

```swift
        let newThumbnail =   Attachment.createThumbnail(from: fullImageData,
                                       thumbnailPixelSize: 200)

        #if os(iOS)
        self.thumbnailData = newThumbnail?.pngData()
        #else
        self.thumbnailData = newThumbnail?.tiffRepresentation
        #endif
        }

        return newThumbnail
```

 Mogę teraz utworzyć inną funkcję, która po prostu opakowuje tę w zadanie (`task`). I dostaję to tutaj. Ale w tym przypadku chcę faktycznie podzielić to na różne zadania. Ponieważ tutaj pracuję nad dwiema głównymi rzeczami. Tworzenie miniaturki ma wyższy priorytet niż na przykład, gdy używam utworzonej miniaturki i po prostu ją buforuję w moich tymczasowych danych miniaturki. Dlatego chcę to mieć osobno. Dlatego dodaję tutaj async/await i zadanie wewnątrz. 

```swift
        let newThumbnail = await Task {
            Attachment.createThumbnail(from: fullImageData,
                                       thumbnailPixelSize: Attachment.maxThumbnailPixelSize)
        }.value

```

 Przejdźmy krok po kroku, co robię. Po pierwsze, sprawdzam, czy mam już dane miniatury, aby zwrócić obraz UI. Ten obraz UI, teraz mogę również użyć mojej funkcji async, create image, aby uczynić to bardziej asynchronicznym. Więc może po prostu napiszę to w dwóch kolejnych linijkach. Obraz, który teraz używam, funkcji await do tworzenia tego jest w moim załączniku, tworzy ten obraz z danych mojej miniatury. Oczywiście opakowuję go, ponieważ wiem, że go mam, a następnie mogę tutaj zwrócić ten obraz, więc zwracam tutaj buforowany obraz, jeśli nic nie mam, sprawdzam, jakie są moje dane pełnoekranowego obrazu, jeśli je mam, chcę teraz utworzyć miniaturkę z tego. Ta funkcja na pewno powinna być w zadaniu lub chcę to wykonać w tle za pomocą zadania. To jest to, co już widziałeś z wybieraczem zdjęć. Zaczynasz od napisania zadania o priorytecie średnim, a operacja jest dokładnie ta i miniaturka to właściwie wartość wewnętrzna. Teraz jest to obraz UI. O to właśnie mi chodziło. Muszę dodać `await` na początku mojego zadania. Czekamy na zakończenie wykonania tego zadania, zanim przejdziemy dalej. Następnie tworzę kolejne zadanie. 

```swift
        Task {
        #if os(iOS)
            self.thumbnailData = newThumbnail?.pngData()
        #else
            self.thumbnailData = newThumbnail?.tiffRepresentation
        #endif
        }
```

 Generujemy dane z tych obrazów. A następnie po prostu zwracam tutaj nową miniaturkę. To jest obraz UI. Teraz, gdy mam tę ładną funkcję asynchroniczną, mogę jej użyć, gdy generuję tę miniaturkę. 

Wracamy do NoteAttachmentView. 

Tutaj, to jest miejsce, gdzie pokazuję wszystkie moje obrazy. Teraz pierwszy błąd jaki nam zgłasza xcode , że funkcja, którą właśnie zmieniłem, jest funkcją asynchroniczną, i nie powinno się ją wywoływać wewnątrz funkcji, która jest ciałem (body), co nie pozwala na użycie async. Więc to jest część, którą teraz powinienem wywołać w zadaniu (task). 



I ponownie, w tym celu muszę mieć to przechowywanie stanu jako private var thumbnailImage. 

```swift
 @State private var thumbnailImage: UIImage? = nil
```

Jest to obraz UI, opcjonalny, zaczynający się od nil. Więc obraz, który pokazuję, to teraz ten obraz miniatury. 

```swift
   var body: some View {   
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
     ...
```

. Ponieważ teraz też się ładuje, powinienem użyć tutaj else. I może dodamy jakąś ikonę zastępczą (placeholder). Na przykład możesz użyć color.gray z ramką (frame) o szerokości 100, wysokości 100. Możesz również użyć 200. Myślę, że użyłem 200 na 200 do przeskalowania go do miniatury. Teraz mamy ten zastępczy obraz i obraz, kiedy mamy jakieś dane /obrazek. I muszę przypiąć moje zadanie gdzieś i dodam to na zewnątrz. Więc muszę mieć tutaj grupę (group) wokół mojego if/else. I możemy dodać zadanie. Mogę pobierać moje załączniki (attachment), aby wygenerować mi tę miniaturę lub pobrać, jeśli jest już w pamięci podręcznej. 

```swift
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
            thumbnailImage =  await attachment.getThumbnail()
        }
```



 Wchodzę tutaj. I powód, dla którego nie jest uruchamiane, Widzisz, pokazuje mi zawsze ten sam obraz. Dzieje się tak, ponieważ ten modyfikator zadania (task modifier) jest połączony z cyklem życia mojego widoku NoteAttachmentView. Ten widok jest zawsze obecny. Jedyną rzeczą, którą tutaj zmieniam, jest moim załącznikiem (attachment). Teraz muszę mu powiedzieć, aby uruchamiał to ponownie, gdy zmienia się mój załącznik. Na szczęście mają identyfikator zadania (task ID). Więc jest on uruchamiany ponownie, ten identyfikator zmienia się, co w moim przypadku mam, gdy zmieniają się załączniki, używam po prostu identyfikatora obiektu. Myślę, że identyfikator musi być hashable i equatable. Tak, to ma sens. Widok musi po prostu wiedzieć, kiedy się zmienia załącznik . Spróbuj ponownie. To jest pierwszy obraz, teraz przechodzę do innego i faktycznie się zmienia. W tym przypadku mamy tę pamięć podręczną, po prostu ją zapisuję i uruchamiam ponownie. Teraz obraz wraca z poprzedniego, a w międzyczasie nie ustawiłem go z powrotem na nil. Kiedy wykonuję to, pierwsza rzecz, którą robię, to bezpośrednie ustawienie obrazu na nil, i teraz faktycznie go resetuję, ponieważ to błąd polegał na pokazywaniu niewłaściwego obrazu z powodu opóźnienia. To z powodu opóźnienia w generowaniu tych obrazów - przychodzą one w dowolnej kolejności, w jakiej chcą, i nie pokazuję poprawnego obrazu. Teraz, dla celów testowych, nie ustawiam obrazu miniatury w bazie danych. Odkomentowuję tutaj funkcję getThumbnail. Więc tutaj, w tym zadaniu, odkomentowuję generowanie, ustawianie miniatury w bazie danych w pamięci podręcznej. Następnym razem, kiedy to się uruchomi, nie będzie nigdy pobierać obrazu z pamięci podręcznej. Zawsze będzie musiało przejść przez to zadanie, które długo się uruchamia, więc możemy to zobaczyć. Więc przechodzę do notatki, a potem przechodzę do kolejnego. To jest to zadanie, które długo trwa. Przychodzi, a ja przechodzę do następnego. To jest szybkie. Teraz, kiedy nie czekam między nimi, przechodzę do tego długo trwającego i od razu idę do innego. Te dwa obrazy tutaj są teraz przetwarzane jednocześnie. I mój mniejszy obraz, ten, w którym jestem, wraca pierwszy, a potem przychodzi drugi. Więc mam problem z aktualizacją, ponieważ wykonuję pracę równoczesną. To, co muszę zrobić, to kiedy ustawiam ten obraz, muszę sprawdzić, czy obraz należy do notatki. Wolałbym właściwie anulować zadanie załącznika, którego już nie potrzebuję, ale nie udało mi się tego zrobić przy użyciu async/await. Każde zadanie ma jednak metodę "cancel", którą można użyć do anulowania, ale jakoś mi to nie wychodziło. To, co mogę przynajmniej zrobić, to sprawdzić, jak to odpowiednio ustawić. Więc w moim widoku załącznika węzła,



To, co właśnie pochodzi, tak naprawdę należy do mojego załącznika, co oznacza, że jakoś muszę porównać, co mam tu pokazać. Więc jeśli `self.attachments.objectID` to, oh, tak naprawdę powinienem to napisać w dwóch liniach. Najpierw zaczynam, tworzę tę nową miniaturę. 

```swift
        .task(id: attachment.imageData) {
            thumbnailImage = nil
            attachmentID = attachment.objectID

            let newThumbnailImage = await attachment.getThumbnail()

            attachment.updateImageSize(to: newThumbnailImage?.size)

            if self.attachmentID == attachment.objectID {
                thumbnailImage = newThumbnailImage
            }
        }
```

 Więc tutaj zaczynam od załącznika start, Tworzenie, pobieranie, ustawianie załącznika, a potem możemy też pokazać identyfikator obiektu. Dobra, teraz po prostu wyczyściłem obszar debugowania, idźmy do węzła, i mamy start, pobieranie i ustawianie. Więc to jest identyfikator załącznika tutaj. Teraz, jeśli przejdę do następnego, i to ustawia. Dobra, tak naprawdę muszę przejść do tego wolniejszego. Dobra, jeśli jestem na małym obrazie i bardzo szybko przechodzę do dużego, to nadal przychodzi. Więc problem polega na tym, że prawdopodobnie powinienem przechowywać ten identyfikator załącznika jako właściwość stanu w moim widoku, a następnie aktualizować go dla nowego. Więc mam coś do porównania poprawnie. Więc to jest nieskończony identyfikator zarządzanego obiektu.

Więc możemy tutaj utworzyć stanową zmienną prywatną var `objectID`, opcjonalnie null, lub może nazwę to `attachmentID`. Następnie tworzę nowe zadanie. Ustawiam obraz miniatury na null.Następnie ustawiam `attachmentID` na nowy identyfikator obiektu załącznika. Więc tutaj, kiedy porównuję to, porównuję to z `self.attachmentID` z załącznikiem, który mam tutaj przechwycony w tym zadaniu. Jeśli to odpowiada, wiem, że pobrałem miniaturę właściwego obrazu. Więc tutaj, jeśli to prawda, jeśli mam właściwy, to wtedy go umieszczam. Nie, tak naprawdę wykonałem to dwa razy. Więc zaczynam od nowa. Idę do dużego obrazu, a potem do małego. I nie nadpisuję mojego dużego obrazu. Więc to jest ten, gdzie wcześniej podwójnie to napisałem. Więc mogę po prostu usunąć wszystkie instrukcje `print`, ponieważ rozwiązaliśmy teraz nasz mały problem. Tak, w jakiś sposób musisz sprawdzić, czy to, co wraca, to naprawdę to, na czym ci zależy w ostatnim czasie. A nie z dużo wcześniejszego. Ale jak widziałeś, to zadanie naprawdę pomogło w poprawie naszego interfejsu użytkownika. Teraz za każdym razem, gdy coś robię, jest aktualizowane od razu, a interfejs użytkownika nie jest blokowany. Przed opuszczeniem przypomnę, że wracam i komentuję to tutaj, moje ustawienie miniatury. Tak więc to jest właściwie używane. I możemy to przetestować jeszcze raz na iPadzie i mamy błąd!. W jakiś sposób na macOS nie musisz tak często importować Core Data a w IOS trzeba to dodać .   Widziałeś teraz, że generowanie tej miniatury to dość dużo pracy, ale zdecydowanie warto używać tego, ponieważ nasz interfejs użytkownika jest znacznie szybszy. Korzystanie również z tych danych tymczasowych w przypadkach, gdy chcesz uczynić swój interfejs użytkownika bardziej responsywnym, ale nie zawsze chcesz tak wiele zachowywać na stałe, jest to dobry przykład bardziej zaawansowanego schematu.

```swift
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

```





Attachment+Helper



```swift
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

```

