-- SUSTAV ZA LUČKU KAPETANIJU
-- upiti_dario.sql
-- Domena: Zaposlenici i HR
-- Tablice: zaposlenik, pozicija, pozicija_zaposlenika, radna_smjena
-- Autor: Dario Šibenik

USE lucka_kapetanija;
-- POGLEDI

-- POGLED: zaposlenik_pozicije
-- Prikaz zaposlenika s osnovnim podacima i dodijeljenim pozicijama.
CREATE OR REPLACE VIEW zaposlenik_pozicije AS
SELECT
    z.id,
    o.puno_ime,
    z.ugovor_o_radu,
    z.placa,
    p.ime_pozicije
FROM zaposlenik z
JOIN osoba o ON z.id_osoba = o.id
LEFT JOIN pozicija_zaposlenika pz ON z.id = pz.id_zaposlenik
LEFT JOIN pozicija p ON pz.id_pozicija = p.id;

-- POGLED: analiza_smjena
-- Sažetak smjena po zaposleniku s prvim i zadnjim evidentiranim datumom.
CREATE OR REPLACE VIEW analiza_smjena AS
SELECT
    o.puno_ime,
    z.placa,
    COUNT(rs.id) AS ukupno_smjena,
    MIN(rs.datum) AS prva_smjena,
    MAX(rs.datum) AS zadnja_smjena
FROM zaposlenik z
JOIN osoba o ON z.id_osoba = o.id
LEFT JOIN radna_smjena rs ON z.id = rs.id_zaposlenik
GROUP BY z.id, o.puno_ime, z.placa;


-- SLOŽENI UPITI

-- UPIT 1: Zaposlenici poredani po plaći unutar svojih pozicija
-- Dobar za brz pregled tko je najplaćeniji na pojedinoj poziciji.
SELECT
    p.ime_pozicije,
    o.puno_ime,
    z.placa
FROM zaposlenik z
JOIN osoba o ON z.id_osoba = o.id
JOIN pozicija_zaposlenika pz ON z.id = pz.id_zaposlenik
JOIN pozicija p ON pz.id_pozicija = p.id
ORDER BY z.placa DESC;

-- UPIT 2: Zaposlenici s najvećim brojem evidentiranih smjena
-- Koristan pregled ukupnog opterećenja po zaposleniku.
SELECT
    o.puno_ime,
    z.placa,
    COUNT(rs.id) AS ukupno_smjena
FROM zaposlenik z
JOIN osoba o ON z.id_osoba = o.id
JOIN radna_smjena rs ON z.id = rs.id_zaposlenik
GROUP BY z.id, o.puno_ime, z.placa
ORDER BY ukupno_smjena DESC;

-- UPIT 3: Broj smjena po mjesecu i vrsti smjene
-- Jednostavan mjesečni pregled rasporeda rada.
SELECT
    MONTH(rs.datum) AS mjesec,
    rs.smjena,
    COUNT(*) AS broj_smjena
FROM radna_smjena rs
GROUP BY MONTH(rs.datum), rs.smjena
ORDER BY mjesec;

-- ISPIS REZULTATA

SELECT '=== TABLICA: zaposlenik ===' AS info;
SELECT * FROM zaposlenik;

SELECT '=== TABLICA: pozicija ===' AS info;
SELECT * FROM pozicija;

SELECT '=== TABLICA: pozicija_zaposlenika ===' AS info;
SELECT * FROM pozicija_zaposlenika;

SELECT '=== TABLICA: radna_smjena ===' AS info;
SELECT * FROM radna_smjena;

SELECT '=== POGLED: zaposlenik_pozicije ===' AS info;
SELECT * FROM zaposlenik_pozicije;

SELECT '=== POGLED: analiza_smjena ===' AS info;
SELECT * FROM analiza_smjena;
