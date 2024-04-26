-- Erabiltzaileak, bere rolak eta bere baimenak

-- use db_jpamt7;

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
    
CREATE OR REPLACE VIEW musikaria_erreprodukzioak
AS select m.IzenArtistikoa AS IzenArtistikoa,es.Totala AS Totala
from (musikaria m join estatistikak es) 
where (m.IDMusikaria = es.IDAudio);

CREATE OR REPLACE VIEW podcaster_erreprodukzioak
AS 
SELECT p.IzenArtistikoa AS IzenArtistikoa,es.Totala AS Totala
from (podcaster p join estatistikak es) 
where (p.IDPodcaster = es.IDAudio);

-- Podcasterren izena eta eta zenbat ikusi dute podcasterra
CREATE OR REPLACE VIEW musikaria_erreprodukzioak
AS 
SELECT p.IzenArtistikoa AS IzenArtistikoa,es.Totala AS Totala
from (podcaster p join estatistikak es) 
where (p.IDPodcaster = es.IDAudio);

-- Musikariaren izena eta eta zenbat entzun dute bere abestiak
CREATE OR REPLACE VIEW musikaria_erreprodukzioak
AS 
SELECT p.IzenArtistikoa AS IzenArtistikoa, es.Totala AS Totala
from (podcaster p join estatistikak es) 
where (p.IDPodcaster = es.IDAudio);

-- Baimenak
GRANT ALL PRIVILEGES ON *.* TO dbAdmin WITH GRANT OPTION;

GRANT SELECT, UPDATE ON db_JPamt7.audio to dbDepartBurua WITH GRANT OPTION;
GRANT SELECT, UPDATE ON db_JPamt7.musikaria to dbDepartBurua WITH GRANT OPTION;
GRANT SELECT, UPDATE ON db_JPamt7.podcast to dbDepartBurua WITH GRANT OPTION;
GRANT SELECT, UPDATE ON db_JPamt7.album to dbDepartBurua WITH GRANT OPTION;
GRANT SELECT ON db_JPamt7.podcaster to dbDepartBurua WITH GRANT OPTION;
GRANT SELECT ON db_JPamt7.bezeroa to dbDepartBurua WITH GRANT OPTION;
GRANT SELECT ON db_JPamt7.erreprodukzioak to dbDepartBurua WITH GRANT OPTION;
GRANT SELECT ON db_JPamt7.estatistikak to dbDepartBurua WITH GRANT OPTION;

-- Analisten baimenak
GRANT SELECT ON db_JPamt7.* to dbAnalista WITH GRANT OPTION;

-- Langileen baimenak
GRANT SELECT, UPDATE, INSERT ON db_JPamt7.abestia to dbLangileak WITH GRANT OPTION;
GRANT SELECT, UPDATE, INSERT ON db_JPamt7.bezeroa to dbLangileak WITH GRANT OPTION;
GRANT SELECT, UPDATE, INSERT ON db_JPamt7.premium to dbLangileak WITH GRANT OPTION;
GRANT SELECT, UPDATE, INSERT ON db_JPamt7.audio to dbLangileak WITH GRANT OPTION;
GRANT SELECT, UPDATE ON db_JPamt7.musikaria to dbLangileak WITH GRANT OPTION;
GRANT SELECT, UPDATE ON db_JPamt7.podcaster to dbLangileak WITH GRANT OPTION;
GRANT SELECT, UPDATE ON db_JPamt7.podcast to dbLangileak WITH GRANT OPTION;
GRANT SELECT, UPDATE ON db_JPamt7.album to dbLangileak WITH GRANT OPTION;
GRANT SELECT ON db_JPamt7.AbestiInformazioa to dbLangileak WITH GRANT OPTION;
GRANT SELECT ON db_JPamt7.PodcastInformazioa to dbLangileak WITH GRANT OPTION;
GRANT SELECT ON db_JPamt7.erreprodukzioak to dbLangileak WITH GRANT OPTION;
GRANT SELECT ON db_JPamt7.estatistikak to dbLangileak WITH GRANT OPTION;

-- Bezeroen baimenak
GRANT SELECT, INSERT, UPDATE, DELETE ON db_JPamt7.gustukoak to dbBezeroa WITH GRANT OPTION;
GRANT SELECT, INSERT, UPDATE, DELETE ON db_JPamt7.playlist to dbBezeroa WITH GRANT OPTION;
GRANT SELECT, INSERT, UPDATE, DELETE ON db_JPamt7.playlist_abestiak to dbBezeroa WITH GRANT OPTION;
GRANT SELECT, UPDATE, INSERT ON db_JPamt7.bezeroa to dbBezeroa WITH GRANT OPTION;
GRANT SELECT, UPDATE, INSERT ON db_JPamt7.premium to dbLangileak WITH GRANT OPTION;
GRANT SELECT ON db_JPamt7.podcast to dbBezeroa WITH GRANT OPTION;
GRANT SELECT ON db_JPamt7.podcaster to dbBezeroa WITH GRANT OPTION;
GRANT SELECT ON db_JPamt7.abestia to dbBezeroa WITH GRANT OPTION;
GRANT SELECT ON db_JPamt7.album to dbBezeroa WITH GRANT OPTION;
GRANT SELECT ON db_JPamt7.audio to dbBezeroa WITH GRANT OPTION;
GRANT SELECT ON db_JPamt7.AbestiInformazioa to dbBezeroa WITH GRANT OPTION;
GRANT SELECT ON db_JPamt7.PodcastInformazioa to dbBezeroa WITH GRANT OPTION;

-- Erabiltzaileak
CREATE USER IF NOT EXISTS "administrador"@"10.5.6.223" IDENTIFIED BY "admin";
CREATE USER IF NOT EXISTS "bezeroAdmin"@"10.5.6.223" IDENTIFIED BY "Y3Ll0w";
CREATE USER IF NOT EXISTS "eider"@"10.5.6.223" IDENTIFIED BY "hoStiongrEl";
CREATE USER IF NOT EXISTS "jon"@"10.5.6.223" IDENTIFIED BY "ArHelIblEiv";
CREATE USER IF NOT EXISTS "ane"@"10.5.6.223" IDENTIFIED BY "ODenTantrAI";
CREATE USER IF NOT EXISTS "markel"@"10.5.6.223" IDENTIFIED BY "aMPEnIDsUrn";
CREATE USER IF NOT EXISTS "aimar"@"10.5.6.223" IDENTIFIED BY "ORANGE";

GRANT dbAdmin TO "administrador"@"10.5.6.223";
GRANT dbDepartBurua TO "eider"@"10.5.6.223";
GRANT dbAnalista TO "jon"@"10.5.6.223";
GRANT dbAnalista TO "ane"@"10.5.6.223";
GRANT dbLangileak TO "markel"@"10.5.6.223";
GRANT dbBezeroa to "bezeroAdmin"@"10.5.6.223";
GRANT dbBezeroa TO "aimar"@"10.5.6.223";