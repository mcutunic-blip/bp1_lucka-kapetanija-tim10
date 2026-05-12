-- SUSTAV ZA LUČKU KAPETANIJU
-- load_data.sql - Učitavanje podataka iz CSV datoteka

USE lucka_kapetanija;

-- Važno:
-- Ova skripta koristi LOAD DATA LOCAL INFILE, pa klijent čita CSV datoteke lokalno.
-- Opcija local_infile mora biti uključena i na serveru i u klijentu koji pokreće skriptu.
-- MySQL Workbench ponekad i dalje vrati Error 2068 i blokira lokalne datoteke.
-- Ako se to dogodi, pokreni ovu skriptu iz terminala preko mysql klijenta.
-- Ako premjestiš projekt, samo prilagodi apsolutnu putanju do data mape.
-- Trenutna putanja za ovaj repo je:
-- /Users/someuser/Personal/Faks/BP1/bp1_lucka-kapetanija-tim10/data/
-- Primjer pokretanja iz terminala:
-- mysql --local-infile=1 -u root -p lucka_kapetanija < /Users/someuser/Personal/Faks/BP1/bp1_lucka-kapetanija-tim10/load_data.sql

-- UČITAVANJE PODATAKA IZ CSV DATOTEKA

LOAD DATA LOCAL INFILE '/Users/someuser/Personal/Faks/BP1/bp1_lucka-kapetanija-tim10/data/drzava.csv'
INTO TABLE drzava
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/someuser/Personal/Faks/BP1/bp1_lucka-kapetanija-tim10/data/grad.csv'
INTO TABLE grad
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/someuser/Personal/Faks/BP1/bp1_lucka-kapetanija-tim10/data/adresa.csv'
INTO TABLE adresa
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/someuser/Personal/Faks/BP1/bp1_lucka-kapetanija-tim10/data/osoba.csv'
INTO TABLE osoba
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/someuser/Personal/Faks/BP1/bp1_lucka-kapetanija-tim10/data/zaposlenik.csv'
INTO TABLE zaposlenik
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/someuser/Personal/Faks/BP1/bp1_lucka-kapetanija-tim10/data/pozicija.csv'
INTO TABLE pozicija
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/someuser/Personal/Faks/BP1/bp1_lucka-kapetanija-tim10/data/pozicija_zaposlenika.csv'
INTO TABLE pozicija_zaposlenika
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/someuser/Personal/Faks/BP1/bp1_lucka-kapetanija-tim10/data/radna_smjena.csv'
INTO TABLE radna_smjena
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/someuser/Personal/Faks/BP1/bp1_lucka-kapetanija-tim10/data/tip_broda.csv'
INTO TABLE tip_broda
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/someuser/Personal/Faks/BP1/bp1_lucka-kapetanija-tim10/data/brod.csv'
INTO TABLE brod
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/someuser/Personal/Faks/BP1/bp1_lucka-kapetanija-tim10/data/pristaniste.csv'
INTO TABLE pristaniste
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/someuser/Personal/Faks/BP1/bp1_lucka-kapetanija-tim10/data/dokovanje.csv'
INTO TABLE dokovanje
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/someuser/Personal/Faks/BP1/bp1_lucka-kapetanija-tim10/data/teret.csv'
INTO TABLE teret
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/someuser/Personal/Faks/BP1/bp1_lucka-kapetanija-tim10/data/manifest.csv'
INTO TABLE manifest
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/someuser/Personal/Faks/BP1/bp1_lucka-kapetanija-tim10/data/skladiste.csv'
INTO TABLE skladiste
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/someuser/Personal/Faks/BP1/bp1_lucka-kapetanija-tim10/data/skladistenje_tereta.csv'
INTO TABLE skladistenje_tereta
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/someuser/Personal/Faks/BP1/bp1_lucka-kapetanija-tim10/data/inspekcija.csv'
INTO TABLE inspekcija
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/someuser/Personal/Faks/BP1/bp1_lucka-kapetanija-tim10/data/certifikat.csv'
INTO TABLE certifikat
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/someuser/Personal/Faks/BP1/bp1_lucka-kapetanija-tim10/data/usluga.csv'
INTO TABLE usluga
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/someuser/Personal/Faks/BP1/bp1_lucka-kapetanija-tim10/data/placanja.csv'
INTO TABLE placanja
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/someuser/Personal/Faks/BP1/bp1_lucka-kapetanija-tim10/data/recenzija_broda.csv'
INTO TABLE recenzija_broda
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- PROVJERA BROJA REDAKA

SELECT 'drzava' AS tablica, COUNT(*) AS broj_redaka FROM drzava
UNION ALL SELECT 'grad', COUNT(*) FROM grad
UNION ALL SELECT 'adresa', COUNT(*) FROM adresa
UNION ALL SELECT 'osoba', COUNT(*) FROM osoba
UNION ALL SELECT 'zaposlenik', COUNT(*) FROM zaposlenik
UNION ALL SELECT 'pozicija', COUNT(*) FROM pozicija
UNION ALL SELECT 'pozicija_zaposlenika', COUNT(*) FROM pozicija_zaposlenika
UNION ALL SELECT 'radna_smjena', COUNT(*) FROM radna_smjena
UNION ALL SELECT 'tip_broda', COUNT(*) FROM tip_broda
UNION ALL SELECT 'brod', COUNT(*) FROM brod
UNION ALL SELECT 'pristaniste', COUNT(*) FROM pristaniste
UNION ALL SELECT 'dokovanje', COUNT(*) FROM dokovanje
UNION ALL SELECT 'teret', COUNT(*) FROM teret
UNION ALL SELECT 'manifest', COUNT(*) FROM manifest
UNION ALL SELECT 'skladiste', COUNT(*) FROM skladiste
UNION ALL SELECT 'skladistenje_tereta', COUNT(*) FROM skladistenje_tereta
UNION ALL SELECT 'inspekcija', COUNT(*) FROM inspekcija
UNION ALL SELECT 'certifikat', COUNT(*) FROM certifikat
UNION ALL SELECT 'usluga', COUNT(*) FROM usluga
UNION ALL SELECT 'placanja', COUNT(*) FROM placanja
UNION ALL SELECT 'recenzija_broda', COUNT(*) FROM recenzija_broda;
