# SwiftData Sample Note App



Cześć wszystkim, witam w X-Coding z Olfiem.

https://youtu.be/hG6O5pVLc54

https://github.com/alfianlosari/NoteAppSwiftData/tree/main

To będzie krótka filmika, w której pokażę wam nową formułę,

którą Apple właśnie wyjaśniła w WWDC23, czyli SIFT DATA.

SIFT DATA sprawia, że łatwo kupować dane używając declaratywnych kodów.

Można zbadać i wylądować dane używając regularnych kodów SIFT.

i jest zaintegrowane bezpośrednio z CvUI

wow, to jest bardzo ciekawe

więc to jest strona wskazówki

jeśli widzisz

możemy po prostu

wyjaśnić model

używając nowego macro SWIFT

i możemy dać atrybut

używając macro

automatyczna przetrwa

zaintegrowane z CvUI

wow, po prostu wyjaśniamy tę krytykę

z związkami i

w zasadzie

otrzymuje przypływ pośrednicy

z dysku

i pokazane w listie CvUI

To jest niesamowite, jeśli o tym patrzysz

więc tak, to jest strona

i w zasadzie teraz

pokażę wam, co będziemy

zbudować w tym

więc tu mamy aplikację node

i w zasadzie

mamy node

jest dwa osoby, not i text, więc w zasadzie możesz stworzyć not i potem możesz

tagować not z mnóstwem tekstów tutaj, może tutaj, możesz tagować

z mnóstwem tekstów, uzyskaj not i jeśli widzisz tutaj ten not jest tagowany z android, iOS i Flutter

Jeśli przejdziemy do taga, to tutaj każdy tag jest związany z notami.

Not ma wiele tagów i tag ma relację, która ma wiele notów.

To jest relacja z wielu, wielu tagami i notami.

To jest dość kompleksna relacja, którą będziemy zbudować używając Swift Data.

Jak widać, będziemy również nauczać się używać kredytów,

jak używać przedmiotów w tej opcji.

Więc powinniśmy być w stanie filtrować tagi lub noty w tej opcji.

Jak widzicie, jest w stanie filtrować tagi.

Tak więc to jest używanie przedmiotów w kredytach.

Tutaj pokażę wam, jak zmienić odwrotność i wysokość.

To jest to, co będziemy uczyć i budować w tym filmie. Używając danych z Swift.

Na przykład, wykonałem nową notę, "learn-web".

Włączę "tag" z "firebase".

Tutaj możemy wykonać filtr z "credited-add" lub "sorted".

Zasadniczo wykorzystujemy "sorted" przez właściwości.

Jest tu dwa właściwości.

Właściwy kontent i

złożony adres.

Jak widzicie tutaj jest czasopis.

Możemy go też zaznaczyć

podchodząc lub wschodząc.

I też go filtrować.

To jest to,

co będziemy zbudować i nauczyć

używając danych z Swift.

W zasadzie

budujemy modeli z

kompleksnymi związkami, wiele do wiele.

I uczymy się jak

tego krytyka używając predicate, używając krótkiego porządku i używając porządku by.

OK, więc zaczynajmy. OK, teraz pozwól mi tylko zamknąć ten symulator.

Pozwól mi też zmaksymować to i potem pozwól mi otworzyć nowy Xcode. W zasadzie wymagań

dla Was, żeby podążać za tym filmem, to należy dołączyć do Xcode 15.

Teraz jest w beta 1, bo zostało wykonane tylko 2 dni temu po przyszedłym keynote.

To również włączy iOS 17 Simulator, który włączy swift data frameworkę,

żebyśmy spróbowali. Zrobimy nowy projekt.

Wybieram aplikację iOS.

Na nazwisko produktu wydaj nam nazwę, jaką chcesz.

Wybieram tylko nazwę "NodeSwiftData".

Upewnij się, że organizacja jest w Define.

Upewnij się, że "SwiftUI" jest wybrane.

Język jest "Swift".

Wybierz "None" na oparciu.

Nie sprawdzaj, włącz "Test" i "Host" w Cloud Kit.

więc spisuj to gdziekolwiek chcesz

OK

więc jest to myślę, że pierwsze co musimy

nauczyć jest jak wyjaśnić model, prawda, używając data Swift

więc spójrzmy na dokumentację tutaj

też podzieliłem link do tej dokumentacji

w opisie poniżej OK OK więc to jest

Przedstawienie, przemyślenie, czyli po prostu kombinowanie technologii z prawdziwymi

technologiami persystencyjnymi danych korekcyjnych i moderną konkurencyjną funkcję Swift.

OK, nie musimy przeczytać całej tej przemyślenia.

Musimy tylko przeczytać te artykuły, chyba, "Przetrwanie modeli aplikacji".

OK.

"Pojawiać klaski modelowe do dostarczania danych używając markerów.

OK.

Pierwsza rzecz to zmieniać klasę w modeli, by zrobić je wciąż w stanie pracować.

Zaczynamy od wyjaśniania klasy na naszej notce.

Musimy więc wyjaśnić model, klasę, w tym modelu SwiftMacro.

Potem musimy wyjaśnić swoje właściwości.

By default, SwiftData włącza wszystkie niekomputerowe właściwości klasy, więc będzie to trwało.

Dlatego, że są kompatybilne do typu, np. prymitywne typy, boleany, integer, string.

To będzie źródłem prawdy dla lejeru modelu aplikacji.

i będzie to przeżywało przez swój danych.

Możemy też ustawić atrybuty dla każdego z tych właściwości.

Myślę, że możemy dać kilka wartości,

takich jak Unique, Spotlight Indicing, Encryption i wiele innych.

To jest kolejny przykład. Jeśli mamy dwóch modeli, możemy zdefiniować

relację używając tego makro. Możemy również zdefiniować zasady delety. Myślę, że możemy użyć

cascade, nullify również. W przypadku cascade, kiedy deletujemy związany obiekt,

obiektu, który będzie też skaskowany do innych obiektów, z którymi się zainteresowało.

Ok, także transiowanie, myślę, że to nie będzie przeżywało dane, to jest tylko transiowanie.

Jak widzicie tutaj, data nie napisała ich wartości na dysku. Ok, myślę, że zacznijmy od

wyjaśniamy modeli zanim zaczniemy.

Tutaj pozwólmy nam wyjaśnić folię.

Nazwijmy ją modelami, wyjaśnijmy file swifty.

Zajmę się nazwiskiem "node" zanim zaczniemy.

Zaczynamy od wyjaśnienia

Klasę Node'a używając modelu Swift Macro. Nie zapomnijcie też importować danych z Swift.

Model i klasa Node. Zdecydujmy się na unikowane ID. Wybrać atrybuty.

i potem przesuńmy "unique" jako opcję właściwego.

Więc wyznaczam go imieniem "id".

Zróbmy to jako średnie.

Następny to jest kontent sam, kontent noty.

Będzie to średnie.

Trzeci to jest "createdAt"

będzie to "date".

"createdAt" x10, "date" not data.

OK, a teraz tworzymy inicjalizator.

Dobra, to jest "node".

A teraz deklarujemy także "tag"

wewnątrz folii modelu.

Dla tego musimy też wypełnić "swiftdata",

deklarować model używając "swiftmacro"

i wypełnić "class tag".

Oraz przywrócę atrybuty, które będą unikować, a także opcję właściwości. Jak widzicie, jest to Encrypt External Storage, który będzie przeżywał binary w eksternalnym stowarzyszeniu. Nie jestem pewien, czy to jest tak. Ale w Core Data są takie mechanizmy, które są potrzebne do stowarzyszenia bloków.

Przepisów, wartości, delizji, spotlight, transformable, i inne. W tym przypadku użyjemy tylko tego unika.

To będzie unikowało obowiązki unika. Nie będzie duplikacji dwóch instrukcji z tym samym ID.

ten tag. Teraz też wymyślę imię dla taga. Zróbmy to.

I myślę, że dla taga zrobimy to proste. Tylko te dwa.

Mamy więc notę, mamy model taga. Co chcemy osiągnąć?

Chcemy mieć wiele związków między notą i tagiem.

Możesz dodawać kilka tekstów do jednej noty i po tym samym tekst ma wiele związanych not.

To jest zbyt dużo związków.

Jak widzicie, to jest dość kompleksne w ramach grafii obiektu, ale używając danych z ZIF to działa jak magia.

Zobaczmy, jest tu związek, w którym w tej chwili zasadniczość będzie nulowana, więc nie będę tego używać.

Być może użyjemy tylko zasadnego wariantu, który nazywa się nullify.

Tutaj wydeklarujemy noty i dodajemy też arce not.

Automatycznie tworzymy relację, skima dla nas pod kółkiem.

Nie zapomnijmy, że do menu do menu musimy dodać relację.

Użyjemy defaulta nullify, a teraz wkładamy tekst. Ustawiamy typ jako "Area of text".

To automatycznie tworzy menu do skamowania związku między notem i tekstem.

Ale musimy jeszcze dodać jedną rzecz, żeby to było pozostałe.

Warto dodać to "inverse" przynajmniej dla beta 1.

Dla następującego beta lub stabilnego wersji nie jestem pewien czy to jest potrzebne.

Warto dodać "inverse" tutaj.

"inverse" jest dla tego "tag.nodes".

"inverse" relacja.

Ok, teraz budowa jest podjęta.

Mamy relację z "tag" i "nodes".

Mamy więc modeli i teraz zobaczmy co musimy zrobić w następnym wypadku.

To już jest, mamy modeli. Konfiguruj model, zanim Shift Data

może eksaminować twoje modeli w sklepie wymagającej, musisz to powiedzieć, więc musimy to powiedzieć

w czasach ruchu, który model powinien przeżywać i opcjonalne konfiguracja do użycia w zbieraniu sklepu.

Aby ustalić stowarzyszenie, możemy użyć tego modelu kontenera,

View modifiera, na podstawowym poziomie, myślę, prawda?

Potem musimy przejść aryj modelowych typów, by przetrwać.

Jeśli używasz View modifiera, wkładaj go na najwyższą część hierarchii widzenia,

żeby wszystkie zbierane widzenia zachowywali odpowiednio zkonfigurowane środki.

OK, to jest do użycia CVUI, ale jeśli nie używasz CVUI, myślę, że możesz użyć tego,

może jeśli wciąż używasz ui-kit w twoim projektu. Więc dodajmy to, idźmy do

aplikacji, not app.swiftdata.app.swift i wpiszmy swiftdata.

Swiftdata, wpiszmy to poniżej swiftu importu ui.

I tutaj wybierzmy default, model container4, więc w zasadzie

Jeśli nie chcecie tego przejścia, to możecie to zostawić w pamięci,

może w przypadku, że chcecie to użyć na testy.

Można użyć w tym przypadku "pass in memory to true".

Jest też "auto save enable" i "under enable".

Wybierzmy tylko zasadniczą wartość dla nich.

Teraz musimy wybrać model "container4".

Przejdźmy przez listę modeli, które mamy na podstawie.

To jest "node.self" i "tag.self".

Teraz mamy model kontenera.

Próbujmy teraz zbudować pierwszy etap, czyli "NodeListView",

gdzie pokażemy listę nodów oraz sekcję, żeby zbudować nową.

Zróbmy to.

Teraz wykonamy kolejny folder, nazwą "views".

W środku tych "views" wykonamy nowe "cvui_view" i nazwę "not-list_view".

W środku jest list widoków, więc importujemy swift data. Jak możemy wyciągnąć dane z list widoków?

Zobaczmy.

Pierwsze, aby uratować model, który będziemy używać do tworzenia D-Notes, musimy dodać to środowisko,

żeby zrealizować sytuację w modelu, użyjemy kontekstu modelowego.

Obiekt odpowiedzialny za danych modelu w pamięci, w koordynacji z kontenerem modelowego,

aby udostępnić proces danych.

Jak możemy otrzymać kontekst? Możemy użyć tego "EnvironmentPropertyWrapper" i wybrać kontekst modelu.

Możemy użyć tego "DeclareThis" i w tym przypadku możemy odwołać konkretny przykład modelu.

Jeśli nie używasz korpusu danych, to możesz uzyskać kontekst w kontencie .main.

Aby uratować dane, zacznijmy od zainicjowania instancji modelu, a potem wpiszemy "insert passing the instance"

i klikamy "Save".

Chcemy wiedzieć, jak możemy wybrać model.

W zasadzie aby wyciągnąć model możemy użyć prawdziwej prawdy w raporcie.

Jak widzicie w tym przykładzie możemy przejść przez "sort by"

To jest prawdziwa prawa, "start date" i "order by"

Nie jestem pewien czy oni nazywają to "reverse" i "forward"

Myślę, że to jest bardzo proste. Zróbmy to i zmienimy to do "not straight"

Tutaj jest "all trips" i zmienię to na "all nodes". Chcemy to wyświetlić na "created at". Chcemy to wyświetlić na "descending".

Także myślę, że tak, "reverse" jest ok.

Także "resonance" będzie pokazany na górze.

"reverse"

Mamy też "environment", który można użyć do włożenia "delete" i mamy "query".

Teraz zbudujmy sekcję, żeby zbudować "node" w "body".

Najpierw pozwólmy, żebyśmy zbudowali "state" tutaj, dla "text" to jest "node.text".

Zasuńmy to z połową koszty.

W kształcie zacznijmy od tworzenia listy.

Pokażę Wam realtime preview.

Mamy listę, zróbmy sekcję.

Wkładamy ją w grupę dyskusji, która może być eksponowana lub zepsutana.

Zostawmy tutaj tekst, a potem mamy tekstowy filtr z pomocą wskazówki w "Enter Text" i przejdziemy przez kąty, które są tekstowe.

Zróbmy to na wieloletniej linii, używając górnego krawędzi.

Zostawmy linię na 2-4.

Użyjemy tego rozmiaru.

Mamy tutaj gridnot, który może być rozwinięty lub zniszczony.

Zdeklarujmy przycisk.

Wpiszmy "save" jako tytuł.

W tym miejscu wkładajmy "call save".

Wykładamy "func createNode".

W Kreative Node, pierwsze co chcemy zrobić to zainicjować instancję Node.

na określenie id użyjemy tylko uid żeby uzyskać jedyną stronę uid i w kontekście przesunąć kontekst

nie tekst i tworzymy to teraz żeby otrzymać wtedy dzień obecny i następnie możemy po prostu

"info.context.insert"

by zapytać o instancję modelu "not shift data"

w tym miejscu musimy ułatwić po ułatwieniu

i możemy "info.context.save"

to jest tylko wyciągający, ale

ponieważ to jest tylko prototyp, prosty aplikacja

będę używał tylko "try optional"

i nie będę używał erroru

ale w Twoim aplikacji

proszę upewnić się, żeby poradzić się z errorem

to jest tylko przykładowy aplikacja

Teraz mamy sekcję "Create Node" i klikamy na "Save" i następnie wyświetlimy listę nody, które możemy zdać z kwerii.

W tym miejscu sprawdzę czy ten not jest pusty. To jest area na noty. Będziemy używać tego kontenta "Unawailable View". To jest nowe w Cview 2023.

Możemy po prostu wybrać tytuł.

Wybrać "Nie masz jeszcze żadnych not".

Wybrać system_image, wybrać symbol not.

Dobrze, nie masz jeszcze żadnych not.

W blokie "else" możemy użyć "for each" i wybrać "all nodes".

Myślę, że to już się zgodnie z identyfikacją, więc nie musimy się martwić.

Zobaczmy, jak to wygląda.

Zrobiliśmy to.

Teraz

aby wyjaśnić kod,

wyjaśnijmy tylko tekst.

Wkładamy go w VStack.

Z połączeniem

"Leading".

Potem

wyjaśnijmy tekst,

W górę jest napis "not the content" a w górę jest napis "not created at"

używając stylu czasu.

Zostawmy też font na "created at" do "caption".

Teraz spróbujmy to zrobić użyjąc simulatora.

Zrobimy włączenie.

Zostawimy tutaj list_view, który powinien być zainicjalowany.

Zacznijmy.

Zacznijmy z tym simulatorem.

Zacznijmy od firmy.

To jest simulator.

Sprawdźmy, czy jest w porządku.

Spróbujmy stworzyć kod.

Przedsięgnijmy.

Zrobiłem.

Udało mi się włożyć kod do kontekstu SwiftData.

Widzimy go w prawdziwym czasie przez kodówkę.

To jest niesamowite.

Jak widać, kod który piszemy jest po prostu użyty w tej kodówce.

I automatycznie odkrywa wszystkie zmiany w kontekście.

W każdym razie, kiedy wkładamy notę, to będzie realizować kryt, obserwując ją pod

naszą głowę.

Zgodnie z tym, jak i z ordynacją, to będzie pokazana w tej archiwie.

Magic.

Naprawdę niesamowite.

Spróbujmy jeszcze raz.

Alvian.

Zbieramy.

Fajnie.

To jest niesamowite.

Jeśli pamiętacie, używamy odwrotnego "Onder by"

więc pokazuje nam listę na górze.

Teraz mamy listę not,

która pozwala nam pokazać noty,

jak również tworzyć nową notę.

Teraz włączę tutaj przycisk "Delete"

w 4H możemy je włączyć na listę.

Kiedy użytkowie wyrzucają na rowę, możemy oddać kod, który będzie przekazywał nam indeks.

Na podstawie indeksu możemy użyć 4-krotnego, nazwamy to indeks.

W tym miejscu możemy wypełnić informację kontext.delete. Możemy użyć wszystkich kodów, używając tego skrytu, by oddać element.

ok, zgodnie z indeksą i odpuszczam to z kontekstu i upewnij się, że po wszystkim

z 4 możemy po prostu to uratować ok, spróbuj opcjonalnego kontekstu uratowania

ok, zbudujmy znowu, zobaczmy czy model został przetrwany czy nie

ok, te poprzednie modeli zostały przetrwane, ponieważ to nowa sesja,

Włączyłem aplikację. Teraz spróbujmy to deletować.

Fajnie, fajnie, fajnie, fajnie.

Niesamowite. Bardzo minimalne kodowanie, ale bardzo wpływające rezultaty.

Ok, to jest naprawdę niesamowite.

Po prostu to zbieram, to jest data Swift.

Ok, teraz mamy listę not.

Przejdźmy dalej, aby stworzyć następną listę, która jest listą tag.

Mamy więc dwa taby, jeden jest dla noty, a drugi dla tekstu.

Będziemy w zasadzie polegać na tej samej struktury.

Będziemy mieć sekcję do tworzenia i sekcję do pokazania listy tekstów.

Będę w zasadzie kopiować i piszeć kod i zrobić jakieś zmienienia.

Kopiuję, piszę.

Tutaj nie mamy kodu, tylko nazwisko.

Zobaczmy, że ordynacja powinna być na górze, więc użyję "forward".

Tutaj powinno być "allText" i to "ArrayOfText".

Mamy też "text" zamiast "notText".

Co jeszcze? Spróbujmy zbudować.

Myślę, że musimy "import" z danym.

Teraz kontynuujemy przez kopiowanie i piszczenie. To jest tylko przykładowe projekty. Nie musimy się martwić o kopiowanie.

To jest tylko przykładowe projekty.

W tym filmie zrobimy trochę zmienienia.

Kreujemy tag.

I potem

powinno być

tag text.

I teraz zmieniamy to do grid tag.

I w tym filmie powinno być

all tags.

I teraz zmieniamy to.

Nie mamy jeszcze żadnych tagów.

Zmieniamy to na symbol tag.

I w foreach

W tym miejscu będzie "allText" i w tym miejscu będzie "text.name" i wybierzemy te teksty, które mają się w kodze "createdText".

W tym miejscu zmieniamy to do "allText". W tym miejscu zmieniamy to do "createText".

Teraz zmienimy to na "initializować tag" zamiast "node".

O, nie wykończyliśmy inicjalizatora?

O, nie, nie wykończyliśmy.

Ok, teraz mamy.

Zobaczmy, czy w "node" musimy znowu zainicjalizować.

Możemy także przyjąć area tag.

Zacznijmy zbudować.

Prawdopodobnie jest tu jakiś błąd.

Mamy tag z inicjalizacją.

Na id użyjemy tylko inicjalizacji id.

Prowadzimy string.

Nazwę możemy dostać z strony tag.

Na noty, po prostu włożymy koszty.

Włączę tekst.

Tutaj musimy zupełnić kryt.

Teraz akceptuje tekst.

Wypiszmy "empty".

Teraz mamy dwa listy.

Jeden jest dla tekstu, drugi dla tekstu.

Zobaczmy, jak to wygląda w kontencie root.app.not-swift-data.app.

Pierwsza rzecz, którą chcę zrobić to wykreować dwa różne proporcje dla listy not.

Tutaj tylko wyjaśniam listę view, a drugi to tag list view.

Teraz możemy użyć typu CPUI tab view.

Mamy dwa taby.

Pierwsza to jest tab listy.

Przepraszam, użyjemy nowej tabu listy.

A druga to jest tab listy.

OK, to jest to.

Dwa taby.

Fajnie, prawda?

Zostawiamy to na "Build" i zakończymy. Pierwsza rzecz, którą chcę zrobić, to wpisać to w "Navigation" tab.

Możemy to zrobić również. Teraz możemy dodać ten item. Tu możemy wybrać nabór, tytuł, które będzie "notes".

I na imię możemy użyć symbolu SF, System Image.

Użyjmy też noty.

Sprawdźmy, co jest w listach tagowych.

Zmienimy to na "Tags" i zmienimy to na "System Image of Tag".

Teraz możemy dodać nazwisko nawigacji.

Nawigacja, nazwisko, tekst.

Zobaczmy jak to wygląda.

OK, wygląda dobrze. Mamy dwa taby.

Jedno to nazwisko nawigacji, a drugie tekst.

Spróbujmy.

Myślę, że musimy wyczyścić tekst po ubezpieczeniu instancji.

Zróbmy to teraz.

Jest to trochę dziwne, jeśli nie wyczyścimy tekstu po włożeniu.

Tutaj ustawiamy "not text state" do "empty string" oraz "text state" do "empty string".

Teraz przejdźmy do następnego zadania, kiedy chcemy, żeby użytkownicy naszej aplikacji

W tym tabie możemy zaznaczyć listę tekstów, które chcemy zrezygnować.

Zacznijmy od stworzenia nowej UI w sekcji "Create Node" gdzie pokazujemy listę tekstów.

Użytkownik może dodawać mnóstwo tekstów.

A te teksty, które zostały przetestowane, mogą być związane z tworzeniem not.

Pierwsza rzecz, którą chcę zrobić, to wrócić do modelu tekstu.

Będę tworzył prawdziwe właściwości.

Te właściwości nie będą trwały.

Jak pamiętacie z dokumentacji,

Dla tego użyję nazwy "isChecked".

Kiedy użytkownik kliknie na tą konkretną teksturę,

to włączymy ją do "true".

W zasadzie

z tym możemy sprawdzić,

w jaką teksturę powinno być włożone

do użytkownika.

Teraz idziemy do "notListView.swift".

Aby wyjaśnić tekst, tworzę też kolejny krytyk.

Użyję tylko nazwy, a odgłosy będą na przodzie.

Użyję wszystkich tekstów.

Będzie to area of text.

Teraz w tej grupie "Create Now Disclosure" zbudujmy kolejną grupę "Disclosure"

pod "Enter Text"

Zostawmy nazwę "Tag with"

I sprawdźmy czy wszystkie teksty są puste

Nie ma tekstów, pokażmy tylko tekst

Nie ma jeszcze tekstów

"Proszę stworzyć jeden z tekstów"

Zostawiamy styl foregrounda na kolor.gray

Jeśli tekst jest bezpośredni, to będziemy kontynuować z 4 tekstami

Wypuszczamy wszystkie teksty

Tutaj użyję "h" i nazwę "tag" i "transient property" i wykroję "spacer" i pokażę system imię.

Zmianę symbolu jest "chat.mark.circle" i będę go renderować.

Renderujemy w formie multi-color.

OK, mamy "edge tag".

Teraz dodaję "frame" z maximum wysokości "infinity" i "alignment" "leading".

Dodajmy również kontent shape, by wszystko było typowe.

Prowadzimy rectangle.

Dodajmy jeszcze gesturę typu "tab".

Tutaj po prostu wypowiadamy "tag is checked".

W tym przypadku, gdy jest to "checked", to chcemy to uncheckować.

Gdy nie jest to "checked", to chcemy to uncheckować, by mogliśmy użyć toggla.

To jest to boli and variable value.

So it will switch to value, false to true or true to false.

Ok, looks good.

Now we need to update the v-step.

To basically show the text as well.

So here let's check if the node.text.count is...

And it's not empty basically.

We're going to show a text.

Let's use text.

Column and then plus.

Wybrać "node.txt" i napisać to na stronie.

Włączymy to z separatorem koma i przestrzeni.

Dodajmy też "font-caption".

Teraz musimy zasubskrybować tekst czekoladowy z "node"

W kodach możemy użyć tekstu z archiwem tekstu.

Użyjemy też tekstu .for_each.

Możemy użyć tekstu .in i sprawdzić czy tekst jest sprawdzony.

Wkładamy go do tekstu lokalnego archiwu.

i wkładamy tutaj tag. Wkładamy tutaj też tag i sprawdzamy czy jest fałszywy.

Jeżeli jest fałszywy, to sprawdzamy, czy jest prawdziwy. Wkładamy to do archiwum, a potem w tym archiwum możemy to przenieść do notu.

to jest to, co się dzieje z tekstem. Teraz spróbujmy to.

Zobaczmy, mamy tu dwa teksty, teraz tworzymy notkę

i na tekście może kupić film,

najnowszy film,

najnowszy film, ok, zbieramy go z filmem, ok jak widać, kiedy klikniemy na to, to

To będzie togować ten gest, a następnie togować ten, jak widzicie, jeśli klikniemy dwóch klików to sprawdzi, sprawdza, sprawdza, sprawdza.

Zobaczmy, czy to działa.

Możemy wybrać mnóstwo tekstów.

Zobaczmy, czy to działa.

Zobaczmy, czy to działa.

Zobaczmy, czy to działa.

Zobaczmy, czy to działa.

Zobaczmy, czy to działa.

Zobaczmy, czy to działa.

Zobaczmy, czy to działa.

Zobaczmy, czy to działa.

Zobaczmy, czy to działa.

Zobaczmy, czy to działa.

Zobaczmy, czy to działa.

Teraz spróbujmy pokazać asociowane noty w tej listopadze tekstowej.

Znajdujemy się w listopadze tekstowej.

Zobaczmy, co się dzieje.

Zacznijmy od tego "for each all tags".

W tym miejscu sprawdzę, czy tag.notes.count>0.

Przejdę do grupy "Disclosure", wpiszę "tag.name", wpiszę string "tag.name" i wykonam "show tag.nodes.count".

W grupie "Disclosure" użyję "for each" i "tag.notes" i "show the note content"

W tym miejscu też dodaję "else". Nie potrzebujemy tego "vstack".

Pokażmy tylko nazwisko "text" bo nie ma tu "nodes". Nie musimy stworzyć grupy "disclosure".

W tym miejscu chcę dodać jeszcze jeden "onDelete" zmodyfikator, ponieważ użytkownik wykonuje swip na noty.

Możemy użyć index.set_in i wykonać index.set_in na każdej.

Portalu korzystamy z dafüriintense.context.delete, także znowu spiszemy dokładny numeryczny.

Spróbujmy.

Zrobimy to.

Otwórzmy tag.

Świetnie.

O, zapomnieliśmy o zakończeniu.

Latest movie jest związany z tagiem movie.

Sample note jest muzyką i filmem.

Mówi, tu są dwa.

Sample note i bio-latest movie.

Muzyka, tu jest jeden.

Ażuret note.

Niesamowite, prawda?

Udało nam się stworzyć ten związek z wielu, wielu.

i nie ma wielu tekstów i tekst ma wiele notatków ok to jest naprawdę niesamowite spróbujmy wyłączyć tekst

ok to działa widzisz tutaj

fajnie spróbujmy wyłączyć muzykę w drugim tekście wow

Zgubiłem się. Nie wiem czy to jest błąd z danych z Swift Beta 1. Nie jestem pewien.

Ale właściwie już to spotkałem. Więc po prostu pozwól mi powiedzieć solucję, przynajmniej

dla Beta 1. Więc po prostu by zrobić to opcjonalne, tak? Tego ID.

Zrobimy to opcjonalne i również noty. Zrobimy to opcjonalne.

Możemy uniknąć tego popadania. Nie jestem pewien, dlaczego to się dzieje. Może

to z powodu dostępności identy w listie,

ale nie wiem. Po prostu popada tak.

Więc kiedy teraz spróbujemy zrobić mnóstwo tagów,

Zróbmy to jeszcze raz, żeby upewnić się, że nie ma krzyżów.

Zostawmy tutaj relatywne teksty.

Muzyka, filmy, 2,

gradająca nota,

1,

zaznaczmy to jako "Negocjacja",

2,

"Safety", OK.

Zostawmy to tutaj,

"Delete", OK.

Nie ma krzyżów.

Nie ma przeszkód.

Jeszcze raz.

Nie ma przeszkód.

To była temporalna rozwiązanie.

Zrobię tylko opcjonalną ID.

Nie będzie przeszkód, kiedy

rozwiązanie

będzie w tym modelu.

Do tej pory

skreowaliśmy notę,

tekst,

z większą ilością związków.

Teraz będziemy

W zasadzie dodamy kustomizację do kwerii, której możemy dać własne przykłady i kwestie.

Dodamy również search text, gdzie możemy używać predicate, aby filtrować ten kontent.

To jest jedna z rzeczy, którą możemy zobaczyć.

Używamy tutaj proprietaria "queryPropertyWrapper".

Chcemy zainstalować ten "sort" parametr i "order" parametr.

Problem jest, że jeśli chcemy zrobić zmiany w tej stronie,

Jeżeli już to zainicjowaliśmy, to nie możemy znowu zrealizować, że to jest faul.

Zobaczmy, że to jest kryj, który możemy dodać do sklepu. W zasadzie nie możemy go zreassignować, ponieważ ten cel jest abstraktowy.

Nie ma sposób, żeby zrealizować update do "sort" i "orderBy".

Musimy znaleźć sposób, w którym to zrobić na podstawie "notListViewParent".

Musimy przeczytać kwery, które znajdują "sort" i "orderBy".

Musimy to zrobić w tej aplikacji, ponieważ rodziców listy not jest w tej aplikacji.

Możemy tu włączyć wszystkie parametry.

Musimy tu zrobić update.

Będziemy prowadzić krytykę, która będzie wskazana przez użytkownika.

Teraz zacznijmy. To może być trochę trudne, ale powinniśmy to zrobić.

Pozostawcie mnie i zrozumiecie, jak to zrobić.

Pierwsza rzecz, którą chcę zrobić to stworzenie nowego filtu.

Dajmy imię filtrów.

Tutaj stworzę nową numerę, która nam pomoże.

Najpierw jest "not short by".

Zróbmy to konformne do "add a developer" i "cast iterable".

Będziemy używać tego do "not list view".

Pamiętajmy, że model node ma 2 parametry, kreowane w Content. Będziemy używać tych parametrów.

Ustawiamy na przykład "user select" i wybrajamy jedno z tych elementów.

Używamy tego elementu "short_by" i możemy to przekazać do "query" z opcji "property wrapper".

W określonym listie.

Drugie to "content".

Zróbmy jeszcze "text string".

To będzie pokazane w UI

Pierwsza jest "Created that"

Tutaj możemy wyłączyć string "Created that"

Druga klawiska to "Content"

Tutaj możemy wyłączyć "Content"

To jest dla "Not short buy"

Teraz tworzymy "Anonym" dla "Order buy"

Właściwie Apple już daje "Forward" i "Reversed"

ale nie sądzę, że możemy to zakonować w extensji, więc użyjmy jeszcze jednego.

w tym przypadku, a tutaj skanujesz i potem skanujesz podchodzące. Skanujesz przed, podchodzący jest

odwrócony. I w tym przypadku, wyłącz "string" i skanujesz podchodzące. Zatrzymaj string, skanujesz, skanujesz, wróć

string of dash sending k. OK.

To się udało. Teraz nawigujemy się do aplikacji not shift data, żeby zacząć implementację.

Zacznijmy od wybrania kilku stawów, które będziemy używać. Pierwszy to, że pokażę też search text na

na górze listy, gdzie użytkownik może napisać.

A potem będziemy filtrować tekst.

Na noty użyjemy kontenta,

a na tekst filtrujemy jego nazwę.

Zdeklarujmy stąd

"state.not.searchText"

i wydajmy string,

"defaultValue" "nt".

Drugi string to "not.shortBy"

i to będzie "enum".

Wydajmy "defaultValue" "not.shortBy"

<tytuł tekstu>

<tytuł tekstu>

<tytuł tekstu>

<tytuł tekstu>

kiedy zainstalują aplikację. Drugi, jak w pierwszym stanie, to będzie tekst "search_text".

OK. Po prostu string, więc pozwólmy, żeby było konsystentne. Zmienimy ten typ, ekspresywny typ,

żeby nie było "search_text". I dla tekstu "tag" mamy tylko "tag_order_by". OK. Nie mamy "short_by",

Mamy tylko "Prompt Property" i to będzie "Order by Ascending"

i "Default Value".

Czy coś się zgubiło?

OK, zakończyliśmy.

Teraz mamy te 5 stron.

Zacznijmy od "Not List View".

Zostawmy tutaj searchable modifier. Przez "text" możemy wybrać "not searchText". Przez "prompt" wybrać "searchText".

Dla tego użyję "left input capitalization" i chcę usunąć auto-capitalizację.

To może być trochę wyczuwające.

Następnie chcemy pokazać menu picker na górze bar na nawigacji.

Możemy użyć tego toolbara.

Włączamy to znajomy list.

Zaczynamy od listu "Toolbar"

Zacznijmy od listu "Toolbar"

Zacznijmy od listu "Toolbar"

W tym miejscu mamy menu

Z tytułem "Toolbar"

Wybieramy "Toolbar"

[typy tekstu]

Następnie klikamy na wybraną.

i w przypadku pętającej, będzie to stawa "NOT_SORT_BY". W tym przypadku możemy użyć "for each" i wypasować "NOT_SORT_BY" na wszystkie przypadki.

Docen Limu tutaj używamy id żeby zmienić to do " NOT_SORT_BY"

Od types mamy odzwierciedlość although musi się physicistsznie odkręcać, to już nie video.

Nie chcę jeszcze napisać.

W tym miejscu zmienię placman do "top bar trailing".

Tutaj będzie "order by"

a tutaj będzie "not ordered by".

To też będzie "not ordered by".

Nie jest to "not ordered by", ale "ordered by" w każdym razie,

ponieważ używa się tego do obu tekstów i not.

W tym samym miejscu do wybrania tekstu. Zatem użyję arrow.up.arrow.down.

Mamy już UI, teraz zbudujemy komputowany propietarz, żeby generować kryj. Zajmijmy się kryjem "not list".

Tym razem typem będzie "query" i pierwszym odpowiednim ordzem jest "node" z rezultatem "node_array".

To jest model i to jest rezultat, który jest aryją "node".

Zacznijmy od "sortOrder".

Możemy sprawdzić, czy jest to "notOrderBy".

W przypadku, że jest "ascending", użyjemy "forward", a "else" będzie "reverse".

Drugie jest dla predikatów. Wybierzmy "Predikat not" - to jest opcjonalne.

Zobaczmy, czy w "not" jest tekst. Zobaczmy, czy jest. Trzymajmy to. "Characters in white spaces and new lines".

Sprawdźmy czy to nie jest puste.

W tym przypadku zasądzimy predicate z unitą.

To jest nowe w CVUI.

Aby stworzyć predicate musimy użyć macro.

W body będzie nam przekazywane instancję modelową.

Możemy użyć tutaj kontenta. Możemy zlokalizować kontenty w sensie sensywnych,

żeby sprawdzić czy te teksty są kontenty, a nie search text.

Więc porównanie to z sensywnym charakterem.

Ale w przypadku beta to jest bardzo ograniczone, nie możemy tego zrobić. Nie jestem pewien czemu.

Funkcja nie wspiera predikatów mikro predikatów. Nie wiem, jeśli to jest fix, albo może używam go źle. Może możesz komentować w opisie.

Teraz po prostu porównuję to na szczęście. Chcę porównać to z insensytywnym przykładem.

Sprawdzę czy to zajął się dostępnym. Zastanawiam się czy jest to dostępne. Ale nie.

Jeśli użyjemy tego, to nie będzie nam to zająć.

[Czyta czytelność]

Tak, to działa.

Teraz kontynuujemy.

[Czyta czytelność]

Tutaj możemy wybrać kwery.

Tutaj możemy przesłać predikat.

Dlatego możemy przejść przez kluczową drogę.

Jeśli nie jest to "content" możemy przejść przez kluczową drogę.

A jeśli jest to "order" możemy przejść przez krótką drogę.

Zróbmy to.

I tutaj zmienię to do "createdAt".

Bo są tylko dwa możliwości.

"notSortBy" i "createdAt".

Próbuję użyć "ternary" w tym krótkim.

Nie chcę używać tych efektów, ale nie wiem, może to dać mi błęd, ale na razie to powinno działać.

Możemy tu po prostu przejść przez listy not.

Kiedy zaczniemy odwzorowanie listy not, możemy przejść przez komputerowe właściwości, czyli listy not.

Kiedy zmieniamy jedno z tych elementów, to będzie to, że trzymając listę not list, przeszedzamy najnowszą listę not list. Próbujmy sprawdzić wyniki.

Zacznijmy od kontentu. Zacznijmy od "short by content" i zrobimy "ascending".

Jestem już na miejscu. Właśnie jest! Mamy już dostęp do swoich sklepów. Będziemy mogli je kupować i zainwestować w nasz produkt.

Piękne, prawda?

Moc tej krytyki z Swift Data.

Możemy dodać krótką liczbę, predikat i też kupienie liczby.

Jest jeszcze jedna abstrakcja, gdzie możemy wpisać też przesłanie.

Jeśli używamy przesłania, możemy dodać dodatkowe konfiguracje,

w tym przypadku, np. w wybrzeżu limit, wybrzeżu offset.

Możesz też wpasować krótki przepis w tamtym wybrzeżu.

W tym filmie, żeby to zrobić proste, nie będę używał wybrzeżu Descriptor.

Ale tylko, żeby dać Wam informację,

jeśli chcecie używać wybrzeżu Descriptor dla kustomizacji.

Ok.

Jedna rzecz, którą zapomniałem tutaj, to przycisk Save.

W zasadzie chcę kontrolować sytuację.

Chcę to wyłączyć, w przypadku gdyby tekst był pusty.

Nie pamiętam, więc zanim skończę, odpiszę to.

Zdecydujmy się na "Disable modifier" i wyłączamy to, by nie było żadnego tekstu.

Robimy to samo na listę tagi.

Zmienimy to na "text" i zobaczmy, czy jest wyłącznie.

Tak jak widzicie, jest to wyłącznie.

Teraz jeszcze jedna rzecz, nareszcie, dla listy tekstowych.

Właściwie nie pokazałem wam filtrowania tekstów, więc spróbujmy.

Sample. Sample. OK.

Filterował się odpowiednio.

Buy. OK.

Ale właściwie nie wiem, z powodu tego problemu z predikatem,

nie możemy używać comparatora z kasą.

Więc...

Nie działa jak się spodziewałem, ale na razie,

do tej pory, to powinno działać.

Zobaczmy, czy jest jakiś trud,

czy może jakiś błąd z beta 1.

Myślę, że to jest dość ograniczone.

Nie możemy nazwać żadnych funkcji globalnych w tym macro.

Dla listy tagowej, po prostu kopiuję,

piszę, zmieniam to na listę tagowej,

zmieniam to na tag i arena tag.

Tutaj trzeba zmienić to do "TagSearchText".

Tutaj też "TagSearchText".

Tutaj nie mamy "sortBy", więc możemy tylko wrzucić kwery.

Na "sort" powinno być tylko nazwa taga, na "keyPath".

Myślę, że to wszystko na kwerę "TagList".

Ok, zepsułem.

Co?

O, przepraszam. To powinno być tag na plik.

I to powinno być nazwisko w mikrofonie.

Plik mikrofonu.

W końcu musimy to przepisać w listach tagowych.

Wszystkie tagi.

Wszystkie tagi.

Przepis w listach tagowych.

OK, wygląda dobrze.

Sprawdźmy.

Zrobimy kilka tagów.

Muzyka.

Filmy.

Zostawiamy tutaj "Entertainment" i "Org". O, zapomniałem o ulewaniu "Toolbar". Zróbmy to tak.

Nawigujmy do listy tagów.

Pod tytułem nawigacji wstawiamy przycisk "Toolbar".

W tym miejscu ustawiamy "Tag Order By".

Powinno być "Tag Order By Text".

Jeszcze jedna rzecz, którą zapomniałem, to "Tag Order By".

Zobaczmy.

Teraz jest to ascending.

Zmienimy to na descending.

Ascending zaczyna się od WMME.

Ascending zaczyna się od Entertainment, Movie, Movies, i Work.

OK, to tyle na temat SwiftData.

Jak widać, mamy na to sukcesywny gracz, który stworzył prototypowe aplikację,

na to, żeby się nauczyć używania data zrywkowej w praktyczny sposób,

tworząc aplikację, która ma

wiele do wielu relacji z relacją między notą i tekstem.

Myślę, że data zrywkowa jest naprawdę niesamowita.

Daje nam możliwość tworzenia

kompleksowej aplikacji offline, którą możemy użyć w klientach

i może używając tego kompleksnego grafika modelowego możemy go później zsynkować.

To jest naprawdę ciekawe, to zsynkowanie Cloud Kit.

Może mogę stworzyć film na tym temat.

Zsynkuje dane klienta automatycznie do Cloud Kit.

Tak, to tyle na ten film.

i mamy świetny WWDC,

reszta tego WWDC23.

Myślę, że jest jeszcze dużo świetnych framworków,

świetnych nowych API, które Apple wydaje.

Może jeśli mogę,

spróbuję wybrać jeszcze jedno ciekawe temat,

mogę zrobić jeszcze jedno krótkie filmik o tym.

Myślę, że jedną z najważniejszych rzeczy

jest te data z Swift.

Nigdy nie spodziewałem się,

że Apple wydaje te WWDC23.

to jest naprawdę zmiana gry.

I tak, do następnego filmu.

Trzymaj się, by być lepszym uczniowcem.

Trzymaj się, by się nauczyć, trzymaj się budowania.

Trzymaj się, by zrobić te rzeczy, które kochasz.

Tak więc,

lubiłeś filmik, to polub go, subskrybuj, jeśli jeszcze nie.

Do następnego. Do widzenia.