-- Erabiltzaileak, bere rolak eta bere baimenak

USE db_JPamt7;
select * from mysql.user;

-- Rolak
CREATE ROLE IF NOT EXISTS dbAdmin, dbDepartBurua, dbAnalista, dbLangileak, dbBezeroa;

-- Baimenak
GRANT ALL PRIVILEGES ON db_JPamt7.* TO dbAdmin WITH GRANT OPTION;

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
CREATE USER IF NOT EXISTS "leire"@"10.5.6.223" IDENTIFIED BY "hoStiongrEl";
CREATE USER IF NOT EXISTS "unai"@"10.5.6.223" IDENTIFIED BY "ArHelIblEiv";
CREATE USER IF NOT EXISTS "irati"@"10.5.6.223" IDENTIFIED BY "ODenTantrAI";
CREATE USER IF NOT EXISTS "markel"@"10.5.6.223" IDENTIFIED BY "aMPEnIDsUrn";
CREATE USER IF NOT EXISTS "julen"@"10.5.6.223" IDENTIFIED BY "ORANGE";

GRANT dbAdmin TO "administrador"@"10.5.6.223";
GRANT dbDepartBurua TO "leire"@"10.5.6.223";
GRANT dbAnalista TO "unai"@"10.5.6.223";
GRANT dbAnalista TO "markel"@"10.5.6.223";
GRANT dbLangileak TO "irati"@"10.5.6.223";
GRANT dbBezeroa to "bezeroAdmin"@"10.5.6.223";
GRANT dbBezeroa TO "julen"@"10.5.6.223";