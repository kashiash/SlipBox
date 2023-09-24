# Fetching Notes

linki pomocnicze: 

https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Predicates/AdditionalChapters/Introduction.html#//apple_ref/doc/uid/TP40001798-SW1

originalny artykuł: https://player.vimeo.com/video/780081104?autopause=1&autoplay=false#t=0.00s





Teraz pokażę ci znacznie więcej przykładów dla NSPredicates. Będziemy szukać różnych warunków. Stworzę nową klasę testową, aby nieco to rozdzielić. To jest klasa testów jednostkowych. To są moje testy pobierania notatek. Tworzę to i znowu muszę to skonfigurować. Usuwam domyślne dane. Muszę ponownie zaimportować Core Data do mojego projektu i potrzebuję kontrolera kontekstu oraz funkcje konfiguracji i usuwania. Teraz możemy zacząć pisać nasz test.

Pierwszy przykład to wyszukiwanie po terminie. Jeśli chcemy znaleźć notatki zawierające dany termin w tytule. Tworzę funkcję testową `searchTermNodes`. Potrzebuję czegoś, w czym mogę szukać w mojej bazie danych, więc tworzę tutaj dwie notatki. 

```swift
func test_search_term_notes() {
  let note1 = Note(title: "Test", context: context)
  let note2 = Note(title: "Dummy", context: context)
  let searchTerm = "tast"
}
```

 Powiedzmy, że chcę teraz wyszukać notatkę numer jeden z tekstem  "test". Muszę zdefiniować mój predykat. To, co chcę zrobić, to porównanie łańcuchów. I to byłoby polem `title`. Muszę sprawdzić bazę danych. Ponieważ nie chcę używać wartości łańcuchowych, robię to samo, co dla folderów, tworząc tutaj statyczną strukturę, w której trzymam wszystkie stałe, nazwy atrybutów.

```swift
//MARK: - define my string constants

struct NoteProperties {
    static let title = "title_"
    static let bodyText = "bodyText_"
    static let status = "status_"
    static let creationDate = "creationDate_"
    
    static let folder = "folder"
    static let keywords = "keywords_"
}
```

Aby dodać to do mojego łańcucha, mogę użyć `%k` jako zastępowanie wartości łańcucha. A argumentem, który chcę podać tutaj, jest termin wyszukiwania. 



```swift
        let predicate = NSPredicate(format: "%K CONTAINS %@",NoteProperties.title , searchTerm as CVarArg)
```



W bazie danych jest to inny typ, więc muszę użyć rzutowania typu `CVarArg`. A jeśli masz właściwość, którą chcesz dodać tutaj, jest to procent dolar. Teraz to jest właściwość, która powinna być podobna do terminu wyszukiwania.

Wróćmy do arkusza z przykładami predykatów: 

 [NSPredicateCheatsheet.pdf](NSPredicateCheatsheet.pdf) 

oficjalna dokumentacja apple :

https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Predicates/AdditionalChapters/Introduction.html#//apple_ref/doc/uid/TP40001798-SW1

. Mamy możliwość przeprowadzenia pewnych porównań łańcuchów. Na przykład mamy `contains`. Więc możemy powiedzieć, że tytuł węzła zawiera termin wyszukiwania. Mogę po prostu dodać tutaj `contains`.



```swift
let predicate = NSPredicate(format: "%K CONTAINS[cd] %@",NoteProperties.title , searchTerm as CVarArg)
```

Dobrze, teraz kontynuujemy z resztą. Tworzę tu moje żądanie. To jest w klasie Note, żądanie pobierania z predykatem. A potem pobieram węzły, próbując wykonać to żądanie pobierania na moim kontekście. 

```swift
    func test_search_term_notes() {
        let note1 = Note(title: "Täst", context: context)
        let note2 = Note(title: "Dummy", context: context)

        let searchTerm = "tast"

        let predicate = NSPredicate(format: "%K CONTAINS[cd] %@",NoteProperties.title , searchTerm as CVarArg)
        let request = Note.fetch(predicate)
        let retrievedNotes = try! context.fetch(request)
    }
```

Mamy teraz wyniki z naszej bazy danych i sprawdzamy, czy naprawdę otrzymujemy to, czego szukaliśmy, czyli nasza notatka nr jeden. Liczba naszych otrzymanych rekordów powinna wynosić jeden. 

 `XCTAssertTrue(retrievedNotes.count == 1)`

A nasze otrzymane notatki powinny zawierać notatkę numer jeden.

`XCTAssertTrue(retrievedNotes.contains(note1))`

 I możesz również dodać tutaj, że otrzymane węzły zawierają węzeł numer dwa. I to jest naprawdę fałsz, więc wykonaj `assert false`. 

 `XCTAssertFalse(retrievedNotes.contains(note2))`

Teraz spróbuj uruchomić ten test i jest poprawny.

```swift

```

 Możesz spróbować, na przykład, jeśli zmienisz termin wyszukiwania na "Tess", z dwoma "S", ponieważ muszę go naprawdę całkowicie zmienić. Teraz nie powinniśmy otrzymywać niczego, test nie powinien nam przechodzić. Teraz cofam te zmiany. Aby to działało i naprawdę uzyskać notatkę, musi to być dość dokładne. Na przykład to, co nie jest obecnie prawidłowe, to jeśli masz wielkie litery zamiast małych liter. Teraz znów go nie znajduje. Jeśli chcesz wykonać wyszukiwanie bez uwzględniania wielkości liter, po `contains` i nawiasach klamrowych, możesz dodać "c" dla wyszukiwania bez uwzględniania wielkości liter.

`let predicate = NSPredicate(format: "%K CONTAINS[c] %@",NoteProperties.title , searchTerm as CVarArg)`

 I to działa. Istnieje także inna możliwość. To jest na przykład z dialektem. Teraz, w zależności od twojego języka, w angielskim nie masz na przykład niemieckich umlałtów czy polskich liter. . Jeśli chcesz zignorować ten dialekt, możesz dodać "cd". 

`let predicate = NSPredicate(format: "%K CONTAINS[cd] %@",NoteProperties.title , searchTerm as CVarArg)`

 Jeśli dodasz [cd], wyszukiwania stają się bardziej kosztowne, ponieważ teraz musi także porównywać wszystkie przypadki bez uwzględniania wielkości liter. I dialekty, więc muszą, tak. Porównywanie łańcucha nie jest już takie proste. Ale to coś, co zdecydowanie powinieneś dodać, ponieważ czasami z różnymi słowami kluczowymi to "ą" lub "ę" nie jest takie łatwe, a ludzie również zapominają. A także wielkie i małe litery. 

```swift
    func test_search_term_notes() {
        let note1 = Note(title: "Täst", context: context)
        let note2 = Note(title: "Dummy", context: context)

        let searchTerm = "tast"

        let predicate = NSPredicate(format: "%K CONTAINS[cd] %@",NoteProperties.title , searchTerm as CVarArg)
        let request = Note.fetch(predicate)

        let retrievedNotes = try! context.fetch(request)

        XCTAssertTrue(retrievedNotes.count == 1)
        XCTAssertTrue(retrievedNotes.contains(note1))
        XCTAssertFalse(retrievedNotes.contains(note2))
    }
```

Dobrze, a teraz dla naszych notatek mamy nie tylko tytuł, w którym można szukać, ale także treść notatki. W tym przypadku chcę wyszukać, czy mój termin wyszukiwania jest zawarty zarówno w tytule, jak i w treści notatki, czyli jest to logiczne lub. W tym przypadku mamy dwa predykaty NS, które chcemy połączyć, złożyć z OR. Tworzę nowy test dla tego. To jest test `searchTermInTitleOrBodyText`. Dobrze, duplikuję to, kopiuję to samo dla jednego z nich. Właściwie powinienem dodać tutaj `bodyText`. Więc musimy zresetować to za pomocą sformatowanego tekstu treści, który jest NSAttributedString z tekstu. Na przykład możemy dodać tutaj "test" dla jednego z nich, a dla drugiego "test" muszę to teraz zmienić. Teraz dodałem "test" zarówno w treści jednego z nich, jak i w tytule drugiego, co oznacza, że jeśli teraz szukam "test", powinienem otrzymać oba. Teraz muszę napisać dwa predykaty i połączyć je. Tworzę tablicę dwóch predykatów. Predykaty. Pierwszy to, po prostu skopiuję tę część.



> Okay, now we continue with the rest. I am creating here my request. This is in the node, the fetch request with predicate. And then I retrieve nodes by try to execute the fetch request on my context. We have now the results up from our database and check if we retrieve really what we searched for, which is our node number one. Our retrieved nodes count should be one. And our retrieved nodes should contain node number one. And you can also add here, retrieved nodes contains node number two. And this is actually false, so execute assert false. Try now to run this test and it's true. You can try, for example, if you change the search term to Tess, with two S, because I need to actually change it completely. Now we should hear not receive anything, yes, and node number one is not in there anymore. Now here I undo the changes. In order to make this work, to really get the node, this needs to be quite exact. For example, what is not current right now is if you have your capital letters instead of small letters. Now it again doesn't find it. If you want to use case-insensitive search, after the contains and curly brackets, you can add a C for case-insensitive. And this works. Then there's another possibility. This is for example with dialectic. Now, depending on your language in English, you don't have this, for example, a German "e" or a "a". They are, if you just search with contains, not the same. If you want to ignore this dialectic, you can add here a "cd". So this is dialectic. And it succeeds again. If you add C and D, the searches get more expensive, because now it needs to also compare all the case insensitive variations. And the dialectics, so they need to, yeah. The string comparison's not so easy anymore. But it's something that you should definitely add, because sometimes with the different keywords, this "eh" or "ah" are not so easy or people forget. And also this capital and small letters. Okay, then for our notes, we not only having here the title that we could search in, we also have the body text. And in this case, I want to search, my search means in plain English, if it's, if the search term is either in the title or in the body text, so it's logical or. And in this case, we have two NS predicates that we want to combine, compound with an or. I'm creating a new test for this. So this is test search term in title or body text. Okay, I am here duplicating, I'm just copying the same for one of them. Actually, I should add here body text. So we have to reset this with the formatted body text, which is the NS attributed string from string. For example, we can add here the test for one of them and the other one, okay, now I need to change this. So now I added test in both of them. In both of my, in one of my notes, I added the test in the body text and the other one in the title, which means that if I search here for test, I should receive both of them. Now I need to write two predicates and compound them. So I'm creating an array of two predicates. Predicates. So the first one is, just going to copy this part. 



So again I say, if it's in the title, and the second one, if it's in the body text, okay I need to now check what the property was in my database and this was the body text underbar. Okay, let's just continue here adding properties. Static let body text underbar. So my second filter is for the body text. So we have one condition where we search it in the title and one time in the body text. And now I need to combine these two predicates to one. So this is predicates and we can create an NS compound predicate from predicates. And as you can imagine, you can compound predicates differently. You can say, I want to have both of my conditions fulfilled. This would be end. You see here with the logical end operation, we have or, or and not operation. So in this case, I said either or, so we use this And here I can give my array of predicates. And now we do the same, I can read, the rest is just the same. This is my nodes fetch request from predicate. I then execute and we check if node number one and two are included. Okay, let's, because I have here this test, I should actually have two nodes in there. Okay, yes, and it's actually telling me the wrong, correctly so I have two and node number two should be now included. So just change the conditions and all my tests pass. You can now change for example one of these texts to the body text to be only tests. Now these two conditions should fail. Yes? Okay. Okay, I undo my change to keep the working test. This kind of compound predicates, you can add more and more. You can now combine this predicate with another one and then with another one of and or. So there's a lot of condition A and B or C. So there's a lot of possibility of combining and creating very advanced predicates. 



For example, another compound fetch would be if I have instead of here one search term, I have two search terms that I want to look for. And I want to have both of them in my title. So I write a new test. So this is a test where we search with multiple terms. Terms in the notes. So again, I am, I need to two nodes. And in this case, I have two. Let's say I have hello world. And the node number one has a text of hello and world. If you would just search for hello space world, then this would, you wouldn't be able to find this node. But because of this, I can individually search for these words. So I start again with an array of predicates. Predicates, this time it's var, because I need to attach more. And as predicate, and I loop for my term in search terms, because then I can append a new one every time. And the one I said we are going to use is again in the title. So it's basically this predicate with the term that I have here. So now I append all of the search terms. You could also add more than just this one. For example, you can also add here. And okay. And now I just need to again do here this compound. And then the actual test is fetching, creating this fetch request and then retrieving, executing the fetch request. And then we test how much results we have. So I said in this case, I only should get back node number one, which also should be contained in the retrieve nodes and the node number two, I should not get back. So that would be false again. Run the test and this succeeds. And I actually want to not use your or, because then either of them would be included. For example, if I have your test more world, I would also get here note number two, but that was not the point. I want to make sure that all of these terms are included. So I changed here my NSCompound predicate to end. So now all of them need to be included. And we only in this case, we really only return note number one. So you can be very specific on what terms you are looking for, if it's "and", "or", you can also combine them in more ways. [BLANK_AUDIO] [BLANK_AUDIO]



