-- SUSTAV ZA LUČKU KAPETANIJU
-- upiti_dario.sql
-- Domena: Zaposlenici i HR
-- Tablice: zaposlenik, pozicija, pozicija_zaposlenika, radna_smjena
-- Autor: Dario Šibenik


USE lucka_kapetanija;
-- ============================================================
-- POGLEDI 
-- ============================================================

-- ------------------------------------------------------------
-- POGLED 1: zaposlenik_pozicije
-- Svaki zaposlenik s listom svojih pozicija, plaćom i stažom.
-- Koristi: JOIN ,LEFT JOIN 
-- ------------------------------------------------------------

CREATE OR REPLACE VIEW zaposlenik_pozicije AS
SELECT
    z.id AS id_zaposlenika,
    o.puno_ime,
    z.ugovor_o_radu,
    z.placa,
    TIMESTAMPDIFF(YEAR, z.datum_zaposlenja, CURDATE()) AS staz,
    p.ime_pozicije
FROM zaposlenik z
JOIN osoba o ON z.id_osoba = o.id
LEFT JOIN pozicija_zaposlenika pz ON z.id = pz.id_zaposlenik
LEFT JOIN pozicija p ON pz.id_pozicija = p.id;

-- ------------------------------------------------------------
-- POGLED 2: analiza_smjena
-- Prikaz broja smjena po zaposleniku i tipu smjene.
-- Koristi: JOIN, LEFT JOIN, GROUP BY, COUNT
-- ------------------------------------------------------------

CREATE OR REPLACE VIEW analiza_smjena AS
SELECT
    z.id AS id_zaposlenika,
    o.puno_ime,
    rs.smjena,
    COUNT(rs.id) AS broj_smjena
FROM zaposlenik z
JOIN osoba o ON z.id_osoba = o.id
LEFT JOIN radna_smjena rs ON z.id = rs.id_zaposlenik
GROUP BY z.id, o.puno_ime, rs.smjena;


-- ------------------------------------------------------------
-- UPIT 1: Zaposlenici s najvećom plaćom po svakoj poziciji
-- Za svaku poziciju pronađi zaposlenika s maksimalnom plaćom.
-- Koristi: JOIN, subquery u WHERE klauzuli, ORDER BY
-- ------------------------------------------------------------


SELECT
    p.ime_pozicije,
    o.puno_ime,
    z.placa
FROM zaposlenik z
JOIN osoba o ON z.id_osoba = o.id
JOIN pozicija_zaposlenika pz ON z.id = pz.id_zaposlenik
JOIN pozicija p ON pz.id_pozicija = p.id
WHERE z.placa = (
    SELECT MAX(z2.placa)
    FROM zaposlenik z2
    JOIN pozicija_zaposlenika pz2 ON z2.id = pz2.id_zaposlenik
    WHERE pz2.id_pozicija = p.id
)
ORDER BY p.ime_pozicije;

-- ------------------------------------------------------------
-- UPIT 2: Zaposlenici koji su radili sva tri tipa smjene
-- Samo oni koji imaju evidenciju za jutarnju, popodnevnu i noćnu.
-- Koristi: JOIN, GROUP BY, HAVING, COUNT DISTINCT
-- ------------------------------------------------------------
SELECT
    o.puno_ime,
    z.placa,
    COUNT(rs.id) AS ukupno_smjena,
    COUNT(DISTINCT rs.smjena) AS broj_tipova_smjena
FROM zaposlenik z
JOIN osoba o ON z.id_osoba = o.id
JOIN radna_smjena rs ON z.id = rs.id_zaposlenik
GROUP BY z.id, o.puno_ime, z.placa
HAVING COUNT(DISTINCT rs.smjena) = 3
ORDER BY ukupno_smjena DESC;

-- ------------------------------------------------------------
-- UPIT 3: Analiza radnih smjena po mjesecu i tipu
-- Koliko smjena je bilo po tipu i koji su bili troškovi.
-- Koristi: GROUP BY, MONTH, COUNT, SUM, agregatne funkcije
-- ------------------------------------------------------------
SELECT
    MONTH(rs.datum) AS mjesec,
    rs.smjena,
    COUNT(*) AS broj_smjena,
    SUM(z.placa) AS ukupni_trosak
FROM radna_smjena rs
JOIN zaposlenik z ON rs.id_zaposlenik = z.id
GROUP BY MONTH(rs.datum), rs.smjena
ORDER BY mjesec;

-- ============================================================
-- ISPIS REZULTATA (za prezentaciju)
-- ============================================================

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
