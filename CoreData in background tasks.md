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

Wracając do NoteAttachmentView. 