-- Erabiltzaileak, bere rolak eta bere baimenak

USE db_JPamt7;
select * from mysql.user;

-- Rolak
CREATE ROLE IF NOT EXISTS dbAdmin, dbDepartBurua, dbAnalista, dbLangileak, dbBezeroa;
GRANT USAGE ON db_JPamt7.* TO dbAdmin;
GRANT USAGE ON db_JPamt7.* TO dbDepartBurua;
GRANT USAGE ON db_JPamt7.* TO dbAnalista;
GRANT USAGE ON db_JPamt7.* TO dbLangileak;
GRANT USAGE ON db_JPamt7.* TO dbBezeroa;


-- Baimenak
GRANT ALL PRIVILEGES ON db_JPamt7.* TO dbAdmin;

GRANT SELECT, UPDATE ON db_JPamt7.audio to dbDepartBurua;
GRANT SELECT, UPDATE ON db_JPamt7.musikaria to dbDepartBurua;
GRANT SELECT, UPDATE ON db_JPamt7.podcast to dbDepartBurua;
GRANT SELECT, UPDATE ON db_JPamt7.album to dbDepartBurua;
GRANT SELECT ON db_JPamt7.podcaster to dbDepartBurua;
GRANT SELECT ON db_JPamt7.bezeroa to dbDepartBurua;
GRANT SELECT ON db_JPamt7.erreprodukzioak to dbDepartBurua;
GRANT SELECT ON db_JPamt7.estatistikakEgunero to dbDepartBurua;
GRANT SELECT ON db_JPamt7.estatistikakAstean to dbDepartBurua;
GRANT SELECT ON db_JPamt7.estatistikakHilabetean to dbDepartBurua;
GRANT SELECT ON db_JPamt7.estatistikakUrtean to dbDepartBurua;
GRANT SELECT ON db_JPamt7.estatistikakTotalak to dbDepartBurua;

-- Analisten baimenak
GRANT SELECT ON db_JPamt7.* to dbAnalista;

-- Langileen baimenak
GRANT SELECT, UPDATE, INSERT ON db_JPamt7.abestia to dbLangileak;
GRANT SELECT, UPDATE, INSERT ON db_JPamt7.bezeroa to dbLangileak;
GRANT SELECT, UPDATE, INSERT ON db_JPamt7.premium to dbLangileak;
GRANT SELECT, UPDATE, INSERT ON db_JPamt7.audio to dbLangileak;
GRANT SELECT, UPDATE ON db_JPamt7.musikaria to dbLangileak;
GRANT SELECT, UPDATE ON db_JPamt7.podcaster to dbLangileak;
GRANT SELECT, UPDATE ON db_JPamt7.podcast to dbLangileak;
GRANT SELECT, UPDATE ON db_JPamt7.album to dbLangileak;
GRANT SELECT ON db_JPamt7.AbestiInformazioa to dbLangileak;
GRANT SELECT ON db_JPamt7.PodcastInformazioa to dbLangileak;
GRANT SELECT ON db_JPamt7.erreprodukzioak to dbLangileak ;
GRANT SELECT ON db_JPamt7.estatistikakEgunero to dbDepartBurua;
GRANT SELECT ON db_JPamt7.estatistikakAstean to dbDepartBurua;
GRANT SELECT ON db_JPamt7.estatistikakHilabetean to dbDepartBurua;
GRANT SELECT ON db_JPamt7.estatistikakUrtean to dbDepartBurua;
GRANT SELECT ON db_JPamt7.estatistikakTotalak to dbDepartBurua;

-- Bezeroen baimenak
GRANT SELECT, INSERT, UPDATE, DELETE ON db_JPamt7.gustukoak to dbBezeroa ;
GRANT SELECT, INSERT, UPDATE, DELETE ON db_JPamt7.playlist to dbBezeroa ;
GRANT SELECT, INSERT, UPDATE, DELETE ON db_JPamt7.playlist_abestiak to dbBezeroa ;
GRANT SELECT, UPDATE, INSERT ON db_JPamt7.bezeroa to dbBezeroa ;
GRANT SELECT, UPDATE, INSERT ON db_JPamt7.premium to dbLangileak ;
GRANT SELECT ON db_JPamt7.podcast to dbBezeroa ;
GRANT SELECT ON db_JPamt7.podcaster to dbBezeroa ;
GRANT SELECT ON db_JPamt7.abestia to dbBezeroa ;
GRANT SELECT ON db_JPamt7.album to dbBezeroa ;
GRANT SELECT ON db_JPamt7.audio to dbBezeroa ;
GRANT SELECT ON db_JPamt7.AbestiInformazioa to dbBezeroa ;
GRANT SELECT ON db_JPamt7.PodcastInformazioa to dbBezeroa ;

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