-- SUSTAV ZA LUČKU KAPETANIJU
-- upiti_jakov.sql
-- Domena: Inspekcija, certifikati, Financije
-- Tablice: inspekcija, placanja, certifikat
-- Autor: Jakov Horvat

USE lucka_kapetanija;

-- ============================================================
-- POGLEDI 
-- ============================================================

-- ------------------------------------------------------------
-- POGLED 1: brod_certifikati
-- tablica brodova i broj certifikata svakog broda
-- Koristi: JOIN i GROUP BY
-- ------------------------------------------------------------

CREATE OR REPLACE VIEW brod_certifikati AS
SELECT
	b.naziv_broda,
    COUNT(c.naziv_certifikata) AS broj_certifikata
FROM certifikat c
JOIN brod b ON c.id_broda = b.id
GROUP BY b.id, b.naziv_broda;

-- ------------------------------------------------------------
-- POGLED 2: promet_po_zaposleniku
-- Prikaz prometa po zaposleniku
-- Koristi: JOIN, LEFT JOIN, GROUP BY, ORDER BY
-- ------------------------------------------------------------

CREATE OR REPLACE VIEW prihod_po_zaposleniku AS
SELECT
	z.id,
    o.puno_ime,
    SUM(p.iznos_u_eurima) AS promet,
    COUNT(p.id_usluge) AS broj_usluga
FROM osoba o
LEFT JOIN zaposlenik z ON o.id = z.id_osoba
JOIN placanja p ON z.id_osoba = p.id_zaposlenika
GROUP BY z.id, o.puno_ime
ORDER BY promet DESC;

-- ------------------------------------------------------------
-- UPIT 1: Brodovi s isteklim certifikatima
-- Lista brodova s nevažećim certifikatima i .
-- Koristi: RIGHT JOIN, curdate(), DATEDIFF(), FLOOR(), CONCAT
-- ------------------------------------------------------------

SELECT
	b.naziv_broda,
	c.naziv_certifikata,
	c.datum_isteka,
    CONCAT(
		FLOOR(DATEDIFF(curdate(), c.datum_isteka) / 365), ' god, ',
		FLOOR((DATEDIFF(curdate(), c.datum_isteka) % 365) / 30), ' mj, ',
		(DATEDIFF(curdate(), c.datum_isteka) % 365) % 30, ' dana'
	) AS istekao_prije
FROM brod b
RIGHT JOIN certifikat c ON b.id = c.id_broda
WHERE c.datum_isteka < curdate();

-- ------------------------------------------------------------
-- UPIT 2: Prihod po uslugama
-- Popis usluga, koliko je prihoda generirala svaka usluga i koliko je puta svaka usluga naplaćena
-- Koristi: JOIN, GROUP BY, HAVING, SUM, COUNT
-- ------------------------------------------------------------
SELECT
    u.naziv_usluge,
    SUM(p.iznos_u_eurima) AS prihod,
    COUNT(p.id_usluge) AS frekvencija_usluge
FROM usluga u
JOIN placanja p ON u.id = p.id_usluge
GROUP BY u.naziv_usluge
HAVING frekvencija_usluge > 0
ORDER BY prihod DESC;
    
-- ------------------------------------------------------------
-- UPIT 3: Prosječna ocjena i prihod generiran od svakog broda
-- prosječna recenzija broda od strane zaposlenika i prihod generiran od svakog broda.
-- Koristi: JOIN, LEFT JOIN, GROUP BY, ORDER BY, AVG, SUM
-- ------------------------------------------------------------
SELECT
    b.naziv_broda,
    AVG(rb.ocjena) AS prosjecna_ocjena,
    SUM(p.iznos_u_eurima) AS prihod
FROM brod b
JOIN recenzija_broda rb ON b.id = rb.id_broda
LEFT JOIN dokovanje d ON b.id = d.id_broda
LEFT JOIN placanja p ON d.id = p.id_dokovanja 
GROUP BY b.naziv_broda
ORDER BY prosjecna_ocjena DESC;

-- ============================================================
-- ISPIS REZULTATA (za prezentaciju)
-- ============================================================

SELECT '=== TABLICA: certifikat ===' AS info;
SELECT * FROM certifikat;

SELECT '=== TABLICA: usluga ===' AS info;
SELECT * FROM usluga;

SELECT '=== TABLICA: placanja ===' AS info;
SELECT * FROM placanja;

SELECT '=== TABLICA: recenzija_broda ===' AS info;
SELECT * FROM recenzija_broda;

SELECT '=== POGLED: prihod_po_zaposleniku ===' AS info;
SELECT * FROM prihod_po_zaposleniku;

SELECT '=== POGLED: brod_certifikati ===' AS info;
SELECT * FROM brod_certifikati;
