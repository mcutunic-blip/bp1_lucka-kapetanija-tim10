-- SUSTAV ZA LUČKU KAPETANIJU
-- upiti_vedran.sql
-- Domena: Brodovi i pristaništa
-- Tablice: tip_broda, brod, pristaniste, dokovanje
-- Autor: Vedran

USE lucka_kapetanija;

-- POGLED: pregled_brodova
-- Ovdje se vidi osnovni pregled svakog broda, zajedno s tipom, državom i kapetanom.
CREATE OR REPLACE VIEW pregled_brodova AS
SELECT
    b.id,
    b.naziv_broda,
    tb.naziv_tipa AS tip_broda,
    d.naziv AS drzava,
    o.puno_ime AS kapetan,
    b.kapacitet_tereta,
    b.godina_proizvodnje

FROM brod b

JOIN tip_broda tb
    ON b.id_tipa_broda = tb.id

JOIN drzava d
    ON b.id_drzava = d.id

JOIN osoba o
    ON b.id_kapetan = o.id;


-- POGLED: aktivna_dokovanja
-- Prikaz brodova koji su još u luci, odnosno nemaju zabilježen odlazak.
CREATE OR REPLACE VIEW aktivna_dokovanja AS

SELECT
    d.id,
    b.naziv_broda AS brod,
    p.naziv AS pristaniste,
    d.datum_dolaska,
    TIMESTAMPDIFF(
        HOUR,
        d.datum_dolaska,
        COALESCE(d.datum_polaska, NOW())
    ) AS sati_u_luci

FROM dokovanje d

JOIN brod b
    ON d.id_broda = b.id

JOIN pristaniste p
    ON d.id_pristanista = p.id

WHERE d.datum_polaska IS NULL;


-- UPIT 1: Brodovi koji su bili u luci u zadnjih 30 dana
-- Kratak pregled nedavnih dolazaka u luku.
SELECT DISTINCT
    b.naziv_broda AS brod,
    d.datum_dolaska

FROM dokovanje d

JOIN brod b
    ON d.id_broda = b.id

WHERE d.datum_dolaska >=
    DATE_SUB(NOW(), INTERVAL 30 DAY);


-- UPIT 2: Pristaništa s najviše dokovanja
-- Korisno za vidjeti koja su pristaništa najopterećenija.
SELECT
    p.naziv AS pristaniste,

    COUNT(d.id)
        AS broj_dokovanja

FROM dokovanje d

JOIN pristaniste p
    ON d.id_pristanista = p.id

GROUP BY p.id, p.naziv

ORDER BY broj_dokovanja DESC

LIMIT 5;


-- UPIT 3: Slobodna pristaništa bez aktivnog dokovanja
-- Izdvaja pristaništa koja su trenutačno dostupna.
SELECT
    p.id,
    p.naziv,
    p.tip_pristanista

FROM pristaniste p

WHERE NOT EXISTS (

    SELECT 1

    FROM dokovanje d

    WHERE d.id_pristanista =
        p.id

    AND d.datum_polaska IS NULL
);



SELECT * FROM pregled_brodova;

SELECT * FROM aktivna_dokovanja;
