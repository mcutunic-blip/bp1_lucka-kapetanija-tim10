-- ============================================================
-- AUTOR: Tomislav
-- Domena: Geografija i osobe
-- Tablice: drzava, grad, adresa, osoba
-- ============================================================

USE lucka_kapetanija;

-- ============================================================
-- POGLEDI (VIEWS)
-- ============================================================

-- POGLED 1: Spajanje osoba s kompletnim podacima o lokaciji prebivališta
CREATE OR REPLACE VIEW pregled_adresa_osoba AS
SELECT 
    o.id AS id_osobe,
    o.puno_ime,
    o.email,
    a.naziv_ulice,
    g.naziv AS grad,
    g.postanski_broj,
    d.naziv AS drzava
FROM osoba o
LEFT JOIN adresa a ON o.id_adresa = a.id
LEFT JOIN grad g ON a.id_grad = g.id
LEFT JOIN drzava d ON g.id_drzava = d.id;


-- POGLED 2: Prikaz ukupnog broja registriranih stanovnika po gradovima
CREATE OR REPLACE VIEW statistika_gradova AS
SELECT 
    g.id AS id_grada,
    g.naziv AS naziv_grada,
    g.postanski_broj,
    COUNT(o.id) AS ukupan_broj_stanovnika
FROM grad g
LEFT JOIN adresa a ON a.id_grad = g.id
LEFT JOIN osoba o ON o.id_adresa = a.id
GROUP BY g.id, g.naziv, g.postanski_broj;


-- ============================================================
--  SQL UPITI
-- ============================================================

-- UPIT 1: Države koje imaju više od jedne registrirane osobe i njihove valute
SELECT 
    d.naziv AS naziv_drzave,
    d.valuta AS sluzbena_valuta,
    COUNT(o.id) AS ukupan_broj_osoba
FROM osoba o
JOIN adresa a ON o.id_adresa = a.id
JOIN grad g ON a.id_grad = g.id
JOIN drzava d ON g.id_drzava = d.id
GROUP BY d.id, d.naziv, d.valuta
HAVING ukupan_broj_osoba > 1
ORDER BY ukupan_broj_osoba DESC;


-- UPIT 2: Punoljetne osobe dostupne putem e-mail kontakta radi slanja obavijesti
SELECT 
    o.puno_ime,
    o.datum_rodenja,
    o.email,
    a.naziv_ulice,
    g.naziv AS naziv_grada,
    g.postanski_broj
FROM osoba o
JOIN adresa a ON o.id_adresa = a.id
JOIN grad g ON a.id_grad = g.id
WHERE YEAR(o.datum_rodenja) < 2007
  AND o.email LIKE '%@%'
ORDER BY g.naziv ASC, o.puno_ime ASC;


-- UPIT 3: Analiza gustoće naseljenosti po gradovima uz prikaz najstarijeg i najmlađeg mještana
SELECT 
    g.naziv AS naziv_grada,
    g.postanski_broj,
    COUNT(o.id) AS broj_osoba_u_gradu,
    MIN(o.datum_rodenja) AS datum_rodenja_najstarije_osobe,
    MAX(o.datum_rodenja) AS datum_rodenja_najmlade_osobe
FROM grad g
JOIN adresa a ON a.id_grad = g.id
JOIN osoba o ON o.id_adresa = a.id
GROUP BY g.id, g.naziv, g.postanski_broj
ORDER BY broj_osoba_u_gradu DESC;


-- ============================================================
-- ISPIS REZULTATA I PROVJERA 
-- ============================================================

-- Provjera pogleda
SELECT '=== POGLED: pregled_adresa_osoba ===' AS info;
SELECT * FROM pregled_adresa_osoba;

SELECT '=== POGLED: statistika_gradova ===' AS info;
SELECT * FROM statistika_gradova;

-- Prikaz sirovih podataka iz tablica
SELECT '=== TABLICA: drzava ===' AS info;
SELECT * FROM drzava LIMIT 5;

SELECT '=== TABLICA: grad ===' AS info;
SELECT * FROM grad LIMIT 5;

SELECT '=== TABLICA: adresa ===' AS info;
SELECT * FROM adresa LIMIT 5;

SELECT '=== TABLICA: osoba ===' AS info;
SELECT * FROM osoba LIMIT 5;
