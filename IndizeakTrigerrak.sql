use db_JPamt7;

-- Artista izena bilatzeko
CREATE INDEX indx_musikariIzena on musikaria(IzenArtistikoa);
CREATE INDEX indx_podcasterIzena on podcaster (IzenArtistikoa);

-- Musikaria eta podcaster albuma edo podcast bilaketa
CREATE INDEX indx_musikariaalbuman ON album (IDMusikaria);
CREATE INDEX indx_podcasterpodcast ON podcast (IDPodcaster);

-- Artisten bere albuma edo podcast bilaketa
CREATE INDEX indx_bezeroa ON premium (IDBezeroa);
CREATE INDEX indx_audio ON podcast (IdAudio);

-- Playlist bilakera
CREATE INDEX indx_playlist_audioa ON playlist (Izenburua);
CREATE INDEX indx_playlist_audioa ON playlist_abestiak (id);

-- Bezeroa bilatu erabiltzailearengatik
CREATE INDEX indx_bezeroa_erabil ON bezeroa(Erabiltzailea);
CREATE INDEX indx_bezeroa_erabil ON premium(Erabiltzailea);

-- Playlits abestien informazioa indizea
CREATE INDEX idx_plalist_Izenburua ON playlist (Izenburua);
CREATE INDEX idx_abestia_IdAudio ON abestia (IdAudio);
CREATE INDEX idx_audio_izena ON audio (Izena);
CREATE INDEX idx_album_izenburua ON album (izenburua);

-- DROP INDIZEAK
/* DROP INDEX indx_musikariIzena ON musikaria;
DROP INDEX indx_podcasterIzena ON podcaster;
DROP INDEX indx_musikariaalbuman ON album;
DROP INDEX indx_podcasterpodcast ON podcast;
DROP INDEX indx_bezeroa ON premium;
DROP INDEX indx_audio ON podcast;
DROP INDEX indx_astean_estatistika_audio ON estatistikak;
DROP INDEX indx_podcaster_errepro_audio ON estatistikak;
DROP INDEX indx_playlist_audioa ON playlist;
DROP INDEX indx_playlist_audioa ON playlist_abestiak;
DROP INDEX indx_bezeroa_erabil ON bezeroa;
DROP INDEX indx_bezeroa_erabil ON premium;
DROP INDEX idx_plalist_Izenburua ON playlist;
DROP INDEX idx_abestia_IdAudio ON abestia;
DROP INDEX idx_audio_izena ON audio;
DROP INDEX idx_album_izenburua ON album; */


-- TRIGGERAK
-- Premium erabiltzaile bat sortzean, automatikoki premium taulan sartuko da.

DELIMITER //
CREATE TRIGGER PremiumTaulaBete
AFTER INSERT ON bezeroa
for each row 
begin
	declare v_IDBezeroa varchar(32);
		SELECT IDBezeroa into v_IDBezeroa
		from bezeroa
		where IDBezeroa = NEW.IDBezeroa AND mota = "premium";

INSERT INTO premium VALUES 
(v_IDBezeroa, date_add(curdate(),  interval 1 year));
end;
//

-- Bezeroa bere kontua desaktibatzean, premium tauletik kendu
DELIMITER //
CREATE TRIGGER PremiumTauletikKendu
AFTER UPDATE ON bezeroa
for each row 
begin

	declare v_IDBezeroa varchar(32);
		SELECT IDBezeroa into v_IDBezeroa
		FROM bezeroa
		WHERE IDBezeroa = OLD.IDBezeroa AND Aktiboa = false;
DELETE FROM premium WHERE IDBezeroa = v_IDBezeroa;
end;
//

-- GERTAERAK
DELIMITER $$
create event PremiumDataMezua on schedule
every 1 day starts current_timestamp()
do
begin
	declare v_IraungitzeData date;
	declare v_IDBezeroa varchar(32);
	declare amaiera bool default 0;
	declare c cursor for
	
	SELECT Iraungitze_data, IDBezeroa
	FROM premium
	WHERE Iraungitze_data < date_sub(curdate(), interval 2 day);
    
	declare continue handler for not found
	set amaiera = 1;
    open c;
    
	while amaiera = 0 do
		fetch c into v_IraungitzeData, v_IDBezeroa;
			insert into MezuaErabiltzaileak values (v_IDBezeroa, concat("Kontuz, zure premium kontua amaituko da: ", v_IraungitzeData, " egunetan, errenobatu edo amaitu"));
    end while;
    close c;

end;
$$

DELIMITER $$
create event PremiumTauletatikKendu on schedule
every 1 day starts current_timestamp()
do
begin

declare v_IDBezeroa varchar(32);
declare amaiera bool default 0;

declare c cursor for

SELECT IDBezeroa 
FROM premium
WHERE Iraungitze_data < date_add(curdate(), interval 2 day);

declare continue handler for not found
set amaiera = 1;
   
    open c;
        while amaiera = 0 do
    fetch c into v_IDBezeroa;
        delete from premium where IDBezeroa = v_IDBezeroa;
		delete from MezuaErabiltzaileak where IDBezeroa = v_IDBezeroa;
    end while;
    close c;

end;
$$