-- Erabiltzaileak, bere rolak eta bere baimenak

<<<<<<< HEAD:BezeroakEtaVistak.sql
use db_JPamt7;

=======
use db_jpamt7;
>>>>>>> 84d437126ff84a61a6489082e6e482bc85062c64:lokala/BezeroakEtaVistak.sql
-- Rolak
CREATE ROLE IF NOT EXISTS dbAdmin, dbDepartBurua, dbAnalista, dbLangileak, dbBezeroa;

-- Bistak
-- Podcast eta abestiaren datu interesgarriak irazkutzeko (izena, album izena, artista eta iraupena)
CREATE OR REPLACE VIEW AbestiInformazioa
AS 
SELECT audio.izena as "Abesti izena", album.izenburua as "Izenburua", musikaria.IzenArtistikoa as "Artista izena", audio.Iraupena as "Iraupena"
    FROM abestia JOIN audio using (IdAudio)
                JOIN album USING (IdAlbum)
                JOIN musikaria USING (IDMusikaria);
                
CREATE OR REPLACE VIEW PodcastInformazioa
AS 
SELECT audio.izena as "Izena", podcast.Kolaboratzaileak as "Kolaboratzaileak", podcaster.IzenArtistikoa as "Artista", audio.Iraupena as "Iraupena"
    FROM podcast JOIN audio using (IdAudio)
                JOIN podcaster USING (IDPodcaster);
                
-- Zenbat bezero eta horietako zeinek PREMIUM ordaintzen dute 
CREATE OR REPLACE VIEW BezeroEtaPremiumKopurua
AS
SELECT count(bezeroa.IDBezeroa) as "Bezero Kopurua", count(premium.IDBezeroa) as "Premium Kantitatea"
    FROM bezeroa LEFT JOIN premium using(IDBezeroa);
<<<<<<< HEAD:BezeroakEtaVistak.sql
    
-- Podcasterren izena eta eta zenbat ikusi dute podcasterra
CREATE OR REPLACE VIEW musikaria_erreprodukzioak
AS 
SELECT m.IzenArtistikoa AS IzenArtistikoa, es.Totala AS Totala
from musikaria m join estatistikak es 
where m.IDMusikaria = es.IdAudio;


-- Musikariaren izena eta eta zenbat entzun dute bere abestiak
CREATE OR REPLACE VIEW podcaster_erreprodukzioak
AS 
SELECT p.IzenArtistikoa AS IzenArtistikoa, es.Totala AS Totala
from (podcaster p join estatistikak es) 
where (p.IDPodcaster = es.IdAudio);



-- Baimenak
GRANT ALL PRIVILEGES ON db_JPamt7.* TO 'dbAdmin'@'localhost';


=======

-- Baimenak
-- Repair table index
REPAIR TABLE mysql.tables_priv;
REPAIR TABLE db;


-- Grant privileges

GRANT ALL PRIVILEGES ON db_jpamt7.* TO 'dbAdmin'@'localhost';

>>>>>>> 84d437126ff84a61a6489082e6e482bc85062c64:lokala/BezeroakEtaVistak.sql

GRANT SELECT, UPDATE ON db_jpamt7.audio to dbDepartBurua;
GRANT SELECT, UPDATE ON db_jpamt7.musikaria to dbDepartBurua;
GRANT SELECT, UPDATE ON db_jpamt7.podcast to dbDepartBurua;
GRANT SELECT, UPDATE ON db_jpamt7.album to dbDepartBurua;
GRANT SELECT ON db_jpamt7.podcaster to dbDepartBurua;
GRANT SELECT ON db_jpamt7.bezeroa to dbDepartBurua;
GRANT SELECT ON db_jpamt7.erreprodukzioak to dbDepartBurua;
GRANT SELECT ON db_jpamt7.estatistikak to dbDepartBurua;

-- Analisten baimenak
GRANT SELECT ON db_jpamt7.* to dbAnalista;

-- Langileen baimenak
GRANT SELECT, UPDATE, INSERT ON db_jpamt7.abestia to dbLangileak;
GRANT SELECT, UPDATE, INSERT ON db_jpamt7.bezeroa to dbLangileak;
GRANT SELECT, UPDATE, INSERT ON db_jpamt7.premium to dbLangileak;
GRANT SELECT, UPDATE, INSERT ON db_jpamt7.audio to dbLangileak;
GRANT SELECT, UPDATE ON db_jpamt7.musikaria to dbLangileak;
GRANT SELECT, UPDATE ON db_jpamt7.podcaster to dbLangileak;
GRANT SELECT, UPDATE ON db_jpamt7.podcast to dbLangileak;
GRANT SELECT, UPDATE ON db_jpamt7.album to dbLangileak;
GRANT SELECT ON db_jpamt7.AbestiInformazioa to dbLangileak;
GRANT SELECT ON db_jpamt7.PodcastInformazioa to dbLangileak;
GRANT SELECT ON db_jpamt7.erreprodukzioak to dbLangileak;
GRANT SELECT ON db_jpamt7.estatistikak to dbLangileak;

select * from mysql.user;

-- Bezeroen baimenak
GRANT SELECT, INSERT, UPDATE, DELETE ON db_jpamt7.gustukoak to dbBezeroa;
GRANT SELECT, INSERT, UPDATE, DELETE ON db_jpamt7.playlist to dbBezeroa;
GRANT SELECT, INSERT, UPDATE, DELETE ON db_jpamt7.playlist_abestiak to dbBezeroa;
GRANT SELECT, UPDATE, INSERT ON db_jpamt7.bezeroa to dbBezeroa;
GRANT SELECT, UPDATE, INSERT ON db_jpamt7.premium to dbLangileak;
GRANT SELECT ON db_jpamt7.podcast to dbBezeroa;
GRANT SELECT ON db_jpamt7.podcaster to dbBezeroa;
GRANT SELECT ON db_jpamt7.abestia to dbBezeroa;
GRANT SELECT ON db_jpamt7.album to dbBezeroa;
GRANT SELECT ON db_jpamt7.audio to dbBezeroa;
GRANT SELECT ON db_jpamt7.AbestiInformazioa to dbBezeroa;
GRANT SELECT ON db_jpamt7.PodcastInformazioa to dbBezeroa;

-- Erabiltzaileak
CREATE USER IF NOT EXISTS administrador@localhost IDENTIFIED BY "admin";
CREATE USER IF NOT EXISTS bezeroAdmin@localhost IDENTIFIED BY "Y3Ll0w";
CREATE USER IF NOT EXISTS eider@localhost IDENTIFIED BY "hoStiongrEl";
CREATE USER IF NOT EXISTS jon@localhost IDENTIFIED BY "ArHelIblEiv";
CREATE USER IF NOT EXISTS ane@localhost IDENTIFIED BY "ODenTantrAI";
CREATE USER IF NOT EXISTS markel@localhost IDENTIFIED BY "aMPEnIDsUrn";
CREATE USER IF NOT EXISTS aimar@localhost IDENTIFIED BY "ORANGE";

GRANT dbAdmin TO administrador@localhost;
GRANT dbDepartBurua TO eider@localhost;
GRANT dbAnalista TO jon@localhost;
GRANT dbAnalista TO ane@localhost;
GRANT dbLangileak TO markel@localhost;
GRANT dbBezeroa to bezeroAdmin@localhost;
<<<<<<< HEAD:BezeroakEtaVistak.sql
GRANT dbBezeroa TO aimar@localhost;
=======
GRANT dbBezeroa TO aimar@localhost;

select * from mysql.user;

GRANT ALL privileges ON *.* TO administrador@localhost;
>>>>>>> 84d437126ff84a61a6489082e6e482bc85062c64:lokala/BezeroakEtaVistak.sql
