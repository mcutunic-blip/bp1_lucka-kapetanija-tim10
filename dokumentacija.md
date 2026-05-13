# Dokumentacija projekta: Sustav za Lučku Kapetaniju

## 1. Uvod

Ovaj projekt nastao je u sklopu kolegija Baze podataka 1 i modelira relacijsku bazu podataka za potrebe lučke kapetanije. Ideja nam je bila obuhvatiti što više stvarnih procesa koji se svakodnevno događaju u luci: dolaske i odlaske brodova, raspoređivanje pristaništa, praćenje tereta, skladištenje robe, inspekcije i certifikate, zaposlenike i na kraju naplatu svega toga.

Namjerno nismo usko fokusirali projekt samo na jedan dio poslovanja. Htjeli smo da baza prati cijeli tok, od trenutka kada brod dolazi u luku, preko tereta koji prevozi, pa sve do konačnog računa za usluge koje je koristio. Zbog toga su tablice međusobno logički povezane i ne djeluju kao izolirani otoci podataka.

Konkretni ciljevi koje smo postavili na početku bili su:

- da baza vjerno modelira odabrani problemski domen
- da sadrži dovoljno tablica i međusobno smislenih veza
- da omogućuje pisanje složenijih SQL upita
- da jasno prikazuje primjenu primarnih i stranih ključeva, M:N veza i pogleda

---

## 2. Trenutno stanje projekta

Projekt trenutno sadrži:

- **20 tablica**
- SQL skripte za poglede i upite raspoređene po članovima tima
- **21 CSV datoteku s podacima**

Glavne datoteke u projektu su:

| Datoteka | Sadržaj |
|---|---|
| `main.sql` | Kreiranje baze `lucka_kapetanija` i svih tablica |
| `load_data.sql` | Učitavanje podataka iz CSV datoteka |
| `upiti_tomislav.sql` | Upiti i pogledi za domenu geografije i osoba |
| `upiti_dario.sql` | Upiti i pogledi za domenu zaposlenika i HR-a |
| `upiti_vedran.sql` | Upiti i pogledi za domenu brodova i pristaništa |
| `upiti_matej.sql` | Upiti i pogledi za domenu tereta i skladišta |
| `upiti_jakov.sql` | Upiti i pogledi za domenu inspekcija, certifikata i financija |
| `data/*.csv` | Testni podaci za punjenje baze |

Projekt je organiziran po semantičkim domenama, pa svaki član tima pokriva svoj dio modela i pripadajuće SQL skripte.

---

## 3. Problemski domen

Lučka kapetanija ovdje je zamišljena kao središnja točka evidencije svega što se u luci zbiva: brodova, ljudi, robe i infrastrukture. Konkretno, sustav prati:

- države, gradove i adrese vezane uz osobe i brodove
- osobe i zaposlenike koji rade u sustavu
- radne pozicije i raspored smjena
- tipove brodova i podatke o pojedinim brodovima
- pristaništa i dokovanja
- teret, manifeste tereta i skladištenje
- inspekcije i certifikate brodova
- lučke usluge i plaćanja
- recenzije brodova

Takav model omogućuje i operativni i analitički pogled na sustav: s jedne strane evidenciju svakodnevnog rada, a s druge statistike, izvještaje i usporedbe.

---

## 4. Struktura baze podataka

| Tablica | Uloga u sustavu |
|---|---|
| `drzava` | Popis država vezanih uz brodove i osobe |
| `grad` | Gradovi koji pripadaju državama |
| `adresa` | Adrese osoba i lokacija |
| `osoba` | Osnovni podaci o osobama |
| `zaposlenik` | Zaposlenici lučke kapetanije |
| `pozicija` | Radna mjesta i opisi pozicija |
| `pozicija_zaposlenika` | Veza između zaposlenika i pozicija (M:N) |
| `radna_smjena` | Evidencija smjena |
| `tip_broda` | Klasifikacija brodova po vrsti |
| `brod` | Osnovni podaci o brodovima |
| `pristaniste` | Pristaništa koja luka koristi |
| `dokovanje` | Dolasci i odlasci brodova |
| `teret` | Vrste tereta i osnovna svojstva robe |
| `manifest` | Veza broda i tereta uz količinu i masu |
| `skladiste` | Skladišni prostori luke |
| `skladistenje_tereta` | Podaci o pohrani određenog tereta |
| `inspekcija` | Evidencija inspekcijskih pregleda |
| `certifikat` | Certifikati i dozvole brodova |
| `usluga` | Lučke usluge koje se naplaćuju |
| `placanja` | Naplata usluga po dokovanjima |
| `recenzija_broda` | Ocjene i komentari o brodovima |

---

## 5. Najvažnije veze između tablica

Iako je tablica dosta, nekoliko veza čini pravu srž modela:

- `grad` -> `drzava`, `adresa` -> `grad`, čime se dobiva geografska hijerarhija
- `osoba` -> `adresa`, `zaposlenik` -> `osoba`, čime su osobni i radni podaci odvojeni
- `pozicija_zaposlenika`, kao M:N veza između zaposlenika i pozicija
- `radna_smjena` -> `zaposlenik`
- `brod` -> `tip_broda`, `drzava`, i opcionalno `osoba` kao kapetan
- `dokovanje` -> `brod` i `pristaniste`
- `manifest` -> `brod` i `teret`
- `skladistenje_tereta` -> `teret` i `skladiste`
- `inspekcija` -> `brod` i `zaposlenik`
- `certifikat` -> `brod`
- `placanja` -> `dokovanje`, `usluga` i `zaposlenik`
- `recenzija_broda` -> `brod` i `osoba`

Najviše poslovne logike vrti se oko tablica `brod`, `dokovanje`, `manifest` i `placanja`, dok geografske i kadrovske tablice daju kontekst ostatku sustava.

---

## 6. Opis ključnih dijelova baze

### 6.1 Geografija i osobe

Tablice `drzava`, `grad`, `adresa` i `osoba` služe tome da svaka osoba u sustavu, bilo da je riječ o zaposleniku ili kapetanu broda, bude vezana uz konkretnu adresu, a svaka adresa uz grad i državu. Time je model pregledniji i normaliziraniji nego da su svi ti podaci spremljeni na jednom mjestu.

### 6.2 Zaposlenici i organizacija rada

Zaposlenik se najprije upisuje kao osoba, a zatim dobiva podatke specifične za radni odnos: plaću, datum zaposlenja i vrstu ugovora. Budući da jedan zaposlenik može imati više pozicija, ta je veza modelirana kroz posebnu M:N tablicu. Raspored smjena vodi se zasebno u tablici `radna_smjena`.

### 6.3 Brodovi i pristaništa

Ovo je operativna jezgra projekta. Svaki brod ima tip i državu registracije, a može imati i evidentiranog kapetana. Dokovanje bilježi dolazak broda u luku, pristanište koje zauzima, količinu tereta koja se unosi ili iznosi i svrhu boravka.

### 6.4 Teret i skladištenje

`manifest` povezuje brod s vrstom tereta i količinom, a `skladistenje_tereta` evidentira gdje je teret pohranjen, koliko ga ima i koliko dugo ostaje u skladištu. Zajedno te tablice daju pregled robnog toka kroz luku.

### 6.5 Inspekcije, certifikati i financije

Ovaj dio pokriva nadzor i financijski aspekt sustava. Evidentirani su rezultati pregleda brodova, rokovi certifikata, naplaćene usluge i konkretni iznosi plaćanja. `recenzija_broda` dodaje i jednostavan mehanizam povratnih informacija kroz ocjene i komentare.

---

## 7. Količina podataka

| Tablica | Broj zapisa |
|---|---:|
| `drzava` | 15 |
| `grad` | 30 |
| `adresa` | 30 |
| `osoba` | 30 |
| `zaposlenik` | 20 |
| `pozicija` | 10 |
| `pozicija_zaposlenika` | 20 |
| `radna_smjena` | 50 |
| `tip_broda` | 8 |
| `brod` | 15 |
| `pristaniste` | 8 |
| `dokovanje` | 30 |
| `teret` | 20 |
| `manifest` | 35 |
| `skladiste` | 8 |
| `skladistenje_tereta` | 40 |
| `inspekcija` | 20 |
| `certifikat` | 25 |
| `usluga` | 15 |
| `placanja` | 35 |
| `recenzija_broda` | 30 |

> Brojevi su dobiveni iz postojećih CSV datoteka, bez zaglavlja.

---

## 8. Pogledi

Pogledi su u projektu organizirani po članovima tima i pripadaju njihovim semantičkim domenama. U ovom trenutku u postojećim SQL datotekama nalaze se sljedeći pogledi:

| # | Pogled | Datoteka | Opis |
|---|---|---|---|
| 1 | `zaposlenik_pozicije` | `upiti_dario.sql` | Zaposlenici s osnovnim podacima i dodijeljenim pozicijama |
| 2 | `analiza_smjena` | `upiti_dario.sql` | Sažetak smjena po zaposleniku |
| 3 | `pregled_brodova` | `upiti_vedran.sql` | Brodovi s tipom, državom i kapetanom |
| 4 | `aktivna_dokovanja` | `upiti_vedran.sql` | Brodovi koji se trenutno nalaze u luci |
| 5 | `teret_po_brodovima` | `upiti_matej.sql` | Zbirni prikaz tereta po brodovima |
| 6 | `kapacitet_skladista` | `upiti_matej.sql` | Popunjenost skladišta |

Pogledi služe kao gotovi izvještaji, tako da nije potrebno svaki put ručno spajati više tablica.

---

## 9. Složeniji SQL upiti

SQL upiti u projektu raspoređeni su po članovima tima i njihovim domenama. U postojećim datotekama trenutno se nalaze sljedeće skupine upita:

- `upiti_dario.sql` sadrži 3 upita iz domene zaposlenika i smjena
- `upiti_vedran.sql` sadrži 3 upita iz domene brodova i pristaništa
- `upiti_matej.sql` sadrži 3 upita iz domene tereta i skladišta

Ti upiti odgovaraju na pitanja poput:

- koji su brodovi bili u luci u posljednjih 30 dana
- koja pristaništa imaju najviše dokovanja
- koja su pristaništa trenutačno slobodna
- koji zaposlenici imaju najveći broj evidentiranih smjena
- kako izgleda raspodjela smjena po mjesecu i vrsti smjene
- kakva je raspodjela tereta po tipu
- kako izgleda manifest robe po brodu
- koliko se stvarno koristi kapacitet brodova

Korišteni SQL elementi uključuju:

- `JOIN` i `LEFT JOIN`
- `GROUP BY`, `ORDER BY` i `LIMIT`
- podupite i `NOT EXISTS`
- agregatne funkcije `SUM`, `AVG`, `COUNT`, `MIN`, `MAX`
- datumske funkcije poput `DATE_SUB`, `MONTH` i `TIMESTAMPDIFF`

---

## 10. Pokretanje projekta

Redoslijed pokretanja projekta je sljedeći:

1. `main.sql` za kreiranje baze i tablica
2. `load_data.sql` za učitavanje podataka
3. po potrebi pojedinačno pokretanje datoteka `upiti_*.sql`

Projekt je pisan za **MySQL**. Učitavanje podataka koristi `LOAD DATA LOCAL INFILE`, pa je potrebno prethodno uključiti `local_infile` i prilagoditi putanje do CSV datoteka ako se projekt nalazi na drugoj lokaciji.

---

## 11. Zaključak

"Sustav za Lučku Kapetaniju" pokriva širok i smislen skup poslovnih procesa unutar jednog relacijskog modela. Baza je dovoljno velika da pokaže ozbiljniji rad s relacijama, normalizacijom, učitavanjem podataka i analitičkim upitima, a istovremeno je dovoljno pregledna da se može razumjeti kao cjelina.

Ono što nam je bilo najvažnije u ovom projektu jest da tablice nisu nepovezane. Svaka ima smisla u kontekstu ostalih. Ljudi, brodovi, teret, infrastruktura i financije tvore jedan koherentan sustav, a upravo to, po našem mišljenju, dobro pokazuje što relacijske baze podataka mogu ponuditi u stvarnom problemskom domenu.
