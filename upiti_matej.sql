-- SUSTAV ZA LUČKU KAPETANIJU
-- Domena: Teret i skladišta
-- Tablice: teret, manifest, skladiste, skladistenje_tereta
-- Autor: Matej

USE lucka_kapetanija;

-- POGLEDI

-- POGLED: teret_po_brodovima
-- Jednostavan pregled koliko tereta ima svaki brod.
CREATE OR REPLACE VIEW teret_po_brodovima AS
SELECT
    b.naziv_broda,
    COUNT(m.id) AS broj_stavki_manifesta,
    SUM(m.kolicina) AS ukupno_komada,
    ROUND(COALESCE(SUM(m.masa_ukupno), 0) / 1000, 2) AS ukupna_masa_tone
FROM brod b
LEFT JOIN manifest m ON b.id = m.id_broda
GROUP BY b.id, b.naziv_broda;

-- POGLED: kapacitet_skladista
-- Jednostavan pregled robe po skladištima.
CREATE OR REPLACE VIEW kapacitet_skladista AS
SELECT
    s.naziv AS skladiste,
    s.tip_skladista,
    COUNT(st.id) AS broj_zapisa,
    COALESCE(SUM(st.kolicina), 0) AS ukupno_komada
FROM skladiste s
LEFT JOIN skladistenje_tereta st ON s.id = st.id_skladista
GROUP BY s.id, s.naziv, s.tip_skladista;


-- UPITI

-- UPIT 1: Analiza tereta po tipu
-- Prikazuje koliko stavki i koliko komada ima za svaki tip tereta.
SELECT
    t.tip_tereta,
    COUNT(*) AS broj_stavki,
    SUM(m.kolicina) AS ukupno_komada
FROM teret t
JOIN manifest m ON t.id = m.id_tereta
GROUP BY t.tip_tereta
ORDER BY ukupno_komada DESC;

-- UPIT 2: Detalji manifesta - odakle kamo putuje roba
-- Pregled osnovnih podataka o prijavljenom teretu.
SELECT
    b.naziv_broda,
    t.naziv_tereta,
    m.kolicina AS komada,
    m.porijeklo_grad AS odakle,
    m.odrediste_grad AS kamo,
    m.datum_registracije
FROM manifest m
JOIN brod b  ON m.id_broda   = b.id
JOIN teret t ON m.id_tereta  = t.id
ORDER BY m.datum_registracije;

-- UPIT 3: Usporedba kapaciteta broda i prevezene mase
-- Usporedba kapaciteta broda i ukupne prijavljene mase tereta.
SELECT
    b.naziv_broda,
    b.kapacitet_tereta AS max_kapacitet_t,
    ROUND(COALESCE(SUM(m.masa_ukupno), 0) / 1000, 2) AS ukupno_prevezeno_t
FROM brod b
LEFT JOIN manifest m ON b.id = m.id_broda
GROUP BY b.id, b.naziv_broda, b.kapacitet_tereta
ORDER BY ukupno_prevezeno_t DESC;


-- ISPIS REZULTATA

SELECT '=== TABLICA: teret ===' AS info;
SELECT * FROM teret;

SELECT '=== TABLICA: manifest ===' AS info;
SELECT * FROM manifest;

SELECT '=== TABLICA: skladiste ===' AS info;
SELECT * FROM skladiste;

SELECT '=== TABLICA: skladistenje_tereta ===' AS info;
SELECT * FROM skladistenje_tereta;

SELECT '=== POGLED: teret_po_brodovima ===' AS info;
SELECT * FROM teret_po_brodovima;

SELECT '=== POGLED: kapacitet_skladista ===' AS info;
SELECT * FROM kapacitet_skladista;
