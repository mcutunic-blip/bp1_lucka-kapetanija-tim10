
-- SUSTAV ZA LUČKU KAPETANIJU
-- main.sql - Kreiranje baze podataka i tablica

DROP DATABASE IF EXISTS lucka_kapetanija;
CREATE DATABASE lucka_kapetanija;
USE lucka_kapetanija;

SET GLOBAL local_infile=1;

-- TABLICA: drzava
-- Opis: Države čiji brodovi mogu biti registrirani ili dolaziti u luku
CREATE TABLE drzava (
    id INT AUTO_INCREMENT PRIMARY KEY,
    naziv VARCHAR(64) NOT NULL,
    pozivni_broj INT NOT NULL,
    valuta VARCHAR(50) NOT NULL,
    tecaj_u_eurima NUMERIC(10,6) NOT NULL,
    opis TEXT
);

-- TABLICA: grad
-- Opis: Gradovi u državama
CREATE TABLE grad (
    id INT AUTO_INCREMENT PRIMARY KEY,
    naziv VARCHAR(64) NOT NULL,
    postanski_broj VARCHAR(32) NOT NULL,
    id_drzava INT NOT NULL,
    opis TEXT,
    FOREIGN KEY (id_drzava) REFERENCES drzava(id)
);

-- TABLICA: adresa
-- Opis: Konkretne adrese osoba ili dijelova luke
CREATE TABLE adresa (
    id INT AUTO_INCREMENT PRIMARY KEY,
    naziv_ulice VARCHAR(128) NOT NULL,
    dodatan_opis TEXT,
    id_grad INT NOT NULL,
    FOREIGN KEY (id_grad) REFERENCES grad(id)
);

-- TABLICA: osoba
-- Opis: Osobe u sustavu - zaposlenici, kapetani i ostali
CREATE TABLE osoba (
    id INT AUTO_INCREMENT PRIMARY KEY,
    puno_ime VARCHAR(100) NOT NULL,
    datum_rodenja DATE NOT NULL,
    kontaktni_broj VARCHAR(15) NOT NULL,
    email VARCHAR(100) NOT NULL,
    id_adresa INT NOT NULL,
    FOREIGN KEY (id_adresa) REFERENCES adresa(id)
);

-- TABLICA: zaposlenik
-- Opis: Zaposlenici lučke kapetanije
CREATE TABLE zaposlenik (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_osoba INT NOT NULL,
    ugovor_o_radu ENUM('studentski', 'honorarno', 'na neodredjeno', 'na odredjeno') NOT NULL,
    placa NUMERIC(10,2) NOT NULL,
    datum_zaposlenja DATE NOT NULL,
    FOREIGN KEY (id_osoba) REFERENCES osoba(id)
);

-- TABLICA: pozicija
-- Opis: Radne pozicije zaposlenika
CREATE TABLE pozicija (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ime_pozicije VARCHAR(100) NOT NULL,
    opis_pozicije TEXT,
    minimalna_placa NUMERIC(10,2)
);

-- TABLICA: pozicija_zaposlenika (M:N veza)
-- Opis: Veza između zaposlenika i pozicija
CREATE TABLE pozicija_zaposlenika (
    id_zaposlenik INT NOT NULL,
    id_pozicija INT NOT NULL,
    PRIMARY KEY (id_zaposlenik, id_pozicija),
    FOREIGN KEY (id_zaposlenik) REFERENCES zaposlenik(id),
    FOREIGN KEY (id_pozicija) REFERENCES pozicija(id)
);

-- TABLICA: radna_smjena
-- Opis: Evidencija radnih smjena zaposlenika
CREATE TABLE radna_smjena (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_zaposlenik INT NOT NULL,
    smjena ENUM('jutarnja', 'popodnevna', 'nocna') NOT NULL,
    datum DATE NOT NULL,
    vrijeme_pocetka TIME,
    vrijeme_kraja TIME,
    FOREIGN KEY (id_zaposlenik) REFERENCES zaposlenik(id)
);

-- TABLICA: tip_broda
-- Opis: Tipovi brodova
CREATE TABLE tip_broda (
    id INT AUTO_INCREMENT PRIMARY KEY,
    naziv_tipa VARCHAR(50) NOT NULL,
    opis TEXT,
    maksimalna_tonaza DECIMAL(12,2)
);

-- TABLICA: brod
-- Opis: Brodovi koji koriste luku
CREATE TABLE brod (
    id INT AUTO_INCREMENT PRIMARY KEY,
    naziv_broda VARCHAR(100) NOT NULL,
    pozivni_znak VARCHAR(20) NOT NULL,
    bruto_tonaza DECIMAL(12,2) NOT NULL,
    neto_tonaza DECIMAL(12,2) NOT NULL,
    kapacitet_tereta DECIMAL(12,2) NOT NULL,
    id_tipa_broda INT NOT NULL,
    id_drzava INT NOT NULL,
    id_kapetan INT,
    godina_proizvodnje INT NOT NULL,
    zadnja_inspekcija DATE,
    FOREIGN KEY (id_tipa_broda) REFERENCES tip_broda(id),
    FOREIGN KEY (id_drzava) REFERENCES drzava(id),
    FOREIGN KEY (id_kapetan) REFERENCES osoba(id)
);

-- TABLICA: pristaniste
-- Opis: Pristaništa dostupna u luki
CREATE TABLE pristaniste (
    id INT AUTO_INCREMENT PRIMARY KEY,
    naziv VARCHAR(100) NOT NULL,
    kapacitet_tereta DECIMAL(12,2) NOT NULL,
    dubina_vode DECIMAL(5,2) NOT NULL,
    tip_pristanista ENUM('kontejnerski', 'tekuci', 'suhi', 'opci') NOT NULL,
    dostupno_od TIME,
    dostupno_do TIME
);

-- TABLICA: dokovanje
-- Opis: Evidencija boravka broda u luci
CREATE TABLE dokovanje (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_broda INT NOT NULL,
    id_pritanista INT NOT NULL,
    datum_dolaska DATETIME NOT NULL,
    datum_polaska DATETIME,
    svrha_boravka VARCHAR(255) NOT NULL,
    broj_tereta_unesen INT DEFAULT 0,
    broj_tereta_izlazak INT DEFAULT 0,
    FOREIGN KEY (id_broda) REFERENCES brod(id),
    FOREIGN KEY (id_pritanista) REFERENCES pristaniste(id)
);

-- TABLICA: teret
-- Opis: Vrste tereta koje prolaze kroz luku
CREATE TABLE teret (
    id INT AUTO_INCREMENT PRIMARY KEY,
    naziv_tereta VARCHAR(100) NOT NULL,
    tip_tereta ENUM('suhi', 'tekuci', 'opasni', 'frigo') NOT NULL,
    opis TEXT,
    masa_kg DECIMAL(12,2) NOT NULL,
    temperatura_min VARCHAR(10),
    temperatura_max VARCHAR(10)
);

-- TABLICA: manifest
-- Opis: Evidencija tereta prijavljenog za brod
CREATE TABLE manifest (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_broda INT NOT NULL,
    id_tereta INT NOT NULL,
    kolicina INT NOT NULL,
    masa_ukupno DECIMAL(12,2) NOT NULL,
    porijeklo_grad VARCHAR(100) NOT NULL,
    odrediste_grad VARCHAR(100) NOT NULL,
    datum_registracije DATE NOT NULL,
    FOREIGN KEY (id_broda) REFERENCES brod(id),
    FOREIGN KEY (id_tereta) REFERENCES teret(id)
);

-- TABLICA: skladiste
-- Opis: Skladišna mjesta u luci
CREATE TABLE skladiste (
    id INT AUTO_INCREMENT PRIMARY KEY,
    naziv VARCHAR(100) NOT NULL,
    kapacitet DECIMAL(12,2) NOT NULL,
    temperatura_kontrola VARCHAR(10),
    tip_skladista VARCHAR(50) NOT NULL,
    lokacija VARCHAR(255)
);

-- TABLICA: skladistenje_tereta
-- Opis: Skladištenje tereta u skladištima
CREATE TABLE skladistenje_tereta (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_tereta INT NOT NULL,
    id_skladista INT NOT NULL,
    id_dokovanja INT,
    kolicina INT NOT NULL,
    datum_skladistenja DATE NOT NULL,
    datum_preuzimanja DATE,
    cijena_po_danu NUMERIC(10,2),
    FOREIGN KEY (id_tereta) REFERENCES teret(id),
    FOREIGN KEY (id_skladista) REFERENCES skladiste(id)
);

-- TABLICA: inspekcija
-- Opis: Sigurnosne inspekcije brodova
CREATE TABLE inspekcija (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_broda INT NOT NULL,
    id_inspektora INT NOT NULL,
    datum_inspekcije DATE NOT NULL,
    rezultat ENUM('prosao', 'neprosao', 'uslovno') NOT NULL,
    napomene TEXT,
    FOREIGN KEY (id_broda) REFERENCES brod(id),
    FOREIGN KEY (id_inspektora) REFERENCES zaposlenik(id)
);

-- TABLICA: certifikat
-- Opis: Certifikati i dozvole brodova
CREATE TABLE certifikat (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_broda INT NOT NULL,
    naziv_certifikata VARCHAR(100) NOT NULL,
    broj_certifikata VARCHAR(50) NOT NULL,
    datum_izdavanja DATE NOT NULL,
    datum_isteka DATE NOT NULL,
    izdao VARCHAR(100) NOT NULL,
    FOREIGN KEY (id_broda) REFERENCES brod(id)
);

-- TABLICA: usluga
-- Opis: Vrste lučkih usluga za koje se naplaćuje
CREATE TABLE usluga (
    id INT AUTO_INCREMENT PRIMARY KEY,
    naziv_usluge VARCHAR(100) NOT NULL,
    opis TEXT,
    cijena_po_toni DECIMAL(8,2),
    cijena_po_satu DECIMAL(8,2),
    cijena_fiksna DECIMAL(10,2)
);

-- TABLICA: placanja
-- Opis: Plaćanja za lučke usluge
CREATE TABLE placanja (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_dokovanja INT NOT NULL,
    id_usluge INT NOT NULL,
    id_zaposlenika INT NOT NULL,
    iznos_u_eurima DECIMAL(12,2) NOT NULL,
    datum_placanja DATE NOT NULL,
    nacin_placanja ENUM('prijevoz', 'gotovina', 'kartice', 'transfer') NOT NULL,
    opis TEXT,
    FOREIGN KEY (id_dokovanja) REFERENCES dokovanje(id),
    FOREIGN KEY (id_usluge) REFERENCES usluga(id),
    FOREIGN KEY (id_zaposlenika) REFERENCES zaposlenik(id)
);

-- TABLICA: recenzija_broda
-- Opis: Recenzije i komentari o brodovima
CREATE TABLE recenzija_broda (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_broda INT NOT NULL,
    id_osobe INT NOT NULL,
    ocjena ENUM('1', '2', '3', '4', '5') NOT NULL,
    komentar TEXT,
    datum DATE NOT NULL,
    FOREIGN KEY (id_broda) REFERENCES brod(id),
    FOREIGN KEY (id_osobe) REFERENCES osoba(id)
);

-- ZAVRŠNA PORUKA
SELECT 'Baza podataka "lucka_kapetanija" uspješno je kreirana.' AS status;
SELECT 'Svih 20 tablica kreirano je sa svim ograničenjima.' AS status;
SELECT 'Sljedeći korak je pokretanje datoteke load_data.sql.' AS status;
