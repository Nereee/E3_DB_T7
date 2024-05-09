use db_JPamt7;

-- Artista bere izena bidez bilatu.
CREATE INDEX indx_musikariIzena on musikaria(IzenArtistikoa);
CREATE INDEX indx_podcasterIzena on podcaster (IzenArtistikoa);

-- Artisten id bidez albuma edo podcast bilatu.
CREATE INDEX indx_musikariaalbuman ON album (IDMusikaria);
CREATE INDEX indx_podcasterpodcast ON podcast (IDPodcaster);

-- Erabiltze izen bidez bezeroa bilatu.
CREATE INDEX indx_bezeroa ON bezeroa (Erabiltzailea);

-- IdAudio bidez podcast eta abestia bilatu.
CREATE INDEX indx_audio ON podcast (IdAudio);

-- IdAudio bidez album-a bilatu.
CREATE INDEX indx_albumAudio ON album (IdAudio);

-- Playlist izen eta idAudio bidez bilatu.
CREATE INDEX idx_plalist_Izenburua ON playlist (Izenburua);
CREATE INDEX indx_playlist_audioa ON playlist_abestiak (IdAudio);

-- ----------------------------------------------------------------------------------- Premium trigger-ak -----------------------------------------------------------------------------------
-- Premium erabiltzaile bat sortzean, automatikoki premium taulan sartuko da.
DELIMITER //
CREATE TRIGGER PremiumTaulaBete
AFTER INSERT ON bezeroa
for each row 
begin
	declare v_IDBezeroa varchar(32);
    declare v_mota enum('Premium','Free');
    
		SELECT IDBezeroa, mota INTO v_IDBezeroa, v_mota
		FROM bezeroa
		WHERE IDBezeroa = NEW.IDBezeroa;
        
        IF v_mota = 'Premium' then
			INSERT INTO premium VALUES (v_IDBezeroa, date_add(curdate(),  interval 1 year));
		END IF;

end;
//

-- Bezeroa bere kontua desaktibatzean, premium tauletik kendu
DELIMITER //
CREATE TRIGGER PremiumTauletikKendu
AFTER UPDATE ON bezeroa
for each row 
begin

	DECLARE v_IDBezeroa varchar(32);
	DECLARE v_mota enum('Premium','Free');
    DECLARE v_aktiboa tinyint(1);
    
		SELECT IDBezeroa, mota, Aktiboa INTO v_IDBezeroa, v_mota, v_aktiboa
		FROM bezeroa
		WHERE IDBezeroa = OLD.IDBezeroa;
        
		IF v_mota = 'Premium' AND v_aktiboa = false then
			DELETE FROM premium WHERE IDBezeroa = v_IDBezeroa;
		END IF;
end;
//

-- Bezeroa bere mota aldatzen badu PREMIUM erosi eta gero, premium taula barruan sartuko da.
DELIMITER //
CREATE TRIGGER PremiumTauletanSartu
AFTER UPDATE ON bezeroa
for each row 
begin

	DECLARE v_IDBezeroa varchar(32);
	DECLARE v_mota enum('Premium','Free');
    
		SELECT IDBezeroa, NEW.mota INTO v_IDBezeroa, v_mota
		FROM bezeroa
		WHERE IDBezeroa = NEW.IDBezeroa;
        
		IF v_mota = 'Premium' THEN
				INSERT INTO premium VALUES (v_IDBezeroa, date_add(curdate(),  interval 1 year));
		END IF;
        
end;
//

-- Bi egun amaitu baino lehenago, erabiltzailea beste tauletatik sartuko da eta mezu bat jasoko du.
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
			INSERT INTO MezuaErabiltzaileak VALUES (v_IDBezeroa, concat("Kontuz, zure premium kontua amaituko da: ", v_IraungitzeData, " egunetan, errenobatu edo amaitu"));
    end while;
    close c;

end;
$$

-- Data pasatzen bada eta erabiltzailea ez badu erosten berriro PREMIUM, mezu tauletatik eta premium tauletatik kenduko da.
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

-- ----------------------------------------------------------------------------------- Estatistikak erreprodukzioak -----------------------------------------------------------------------------------

-- SHOW EVENTS;

-- Erreprodukzio bat egitean EguneroEstatistika tauletan sartuko da.
DELIMITER //
CREATE TRIGGER estatistikakEguneroErreprodukzioa
AFTER INSERT ON erreprodukzioak
FOR EACH ROW
BEGIN

DECLARE audio_kop INT;
    
SELECT COUNT(*) INTO audio_kop 
FROM estatistikakEgunero
WHERE
    IdAudio = NEW.IdAudio
        AND eguna = DATE(NEW.erreprodukzio_data);
    if audio_kop > 0 THEN   
        UPDATE estatistikakEgunero
        SET TopEntzundakoak = TopEntzundakoak + 1
        WHERE IdAudio = NEW.IdAudio AND eguna = DATE(NEW.erreprodukzio_data);
    else
        insert into estatistikakEgunero (IdAudio, eguna, GustokoAbestiak, GustokoPodcast, TopEntzundakoak)
        values (NEW.IdAudio, DATE(NEW.erreprodukzio_data), 0, 0, 1); 
    END IF;
END;
// 

-- Berdina, baina gustoko bat sartzekoan begiratuko du ea Podcast edo Abestia bada eta insert bat edo bestea egingo du.
DELIMITER //
-- Estatistikak gustukoak
CREATE TRIGGER estatistikakEguneroGustukoak
AFTER INSERT ON gustukoak
FOR EACH ROW
BEGIN

DECLARE audio_kop INT;
DECLARE v_mota enum('Podcasta','Abestia');

-- Begiratu ea abesti edo podcast hori badago taulan.
SELECT COUNT(*) INTO audio_kop
FROM estatistikakEgunero 
WHERE IdAudio = NEW.IdAudio;
	
-- Mota berrezkuratu.
SELECT mota into v_mota
FROM audio 
WHERE IdAudio = NEW.IdAudio;

	-- Audio hori badago, update egingo da. Podcast edo abestia bada egiaztatu egingo da.
    IF audio_kop > 0 THEN   
		IF v_mota = 'Abestia' THEN
			UPDATE estatistikakEgunero
			SET GustokoAbestiak = GustokoAbestiak + 1
			WHERE IdAudio = NEW.IdAudio;
		ELSE
			UPDATE estatistikakEgunero
			SET GustokoPodcast = GustokoPodcast + 1
			WHERE IdAudio = NEW.IdAudio;
        END IF;
	-- Ez badago, insert bat egingo da.
    ELSE
		IF v_mota = 'Podcasta' THEN
				insert into estatistikakEgunero (IdAudio, eguna, GustokoAbestiak, GustokoPodcast, TopEntzundakoak)
				values (NEW.IdAudio, curdate(), 0, 1, 0); 
		ELSE 
				insert into estatistikakEgunero (IdAudio, eguna, GustokoAbestiak, GustokoPodcast, TopEntzundakoak)
				values (NEW.IdAudio, curdate(), 1, 0, 0); 
		END IF;
    END IF;
END;
//

-- Astean behin, datu osoak beteko dira.
DELIMITER //
-- estatistikakAstean tauletan txertatu.
CREATE EVENT insert_estatistikakAstean
ON SCHEDULE EVERY 1 WEEK
-- STARTS 'YYYY-MM-DD 00:00:00'
DO
BEGIN
    DECLARE lehen_date DATE;
    DECLARE azken_date DATE;
    
    -- Astearen lehen eguna lortu (astelehena) eta gorde.
    SET lehen_date = DATE_SUB(CURRENT_DATE(), INTERVAL WEEKDAY(CURRENT_DATE()) DAY);
    
    -- Astearen azken eguna lortu (igandea) eta gorde.
    SET azken_date = DATE_ADD(lehen_date, INTERVAL 6 DAY);

    -- estatistikakAstean tauletan datu itxitak sartu.
    INSERT INTO estatistikakAstean (IdAudio, GustokoAbestiak, GustokoPodcast, TopEntzundakoak)
    SELECT IdAudio, SUM(GustokoAbestiak), SUM(GustokoPodcast), SUM(TopEntzundakoak)
    FROM estatistikakEgunero
    WHERE eguna BETWEEN lehen_date AND azken_date
    GROUP BY IdAudio;
END;
//

-- Berdina baina hilabetea bukatzean, datu gustiak beteko dira.
DELIMITER //
-- estatistikakHilabetean tauletan txertatu.
CREATE EVENT insert_estatistikakHilabetean
ON SCHEDULE EVERY 1 MONTH
-- STARTS 'YYYY-MM-01 00:00:00'
DO
BEGIN
    DECLARE lehen_date DATE;
    DECLARE azken_date DATE;
    
    -- Hilabetearen hasierako data lortu eta gorde.
    SET lehen_date = DATE_FORMAT(CURRENT_DATE(), '%Y-%m-01');
    
    -- Hilabetearen azken data lortu eta gorde.
    SET azken_date = LAST_DAY(lehen_data);

    -- estatistikakHilabetean tauletan datuak sartu.
    INSERT INTO estatistikakHilabetean (IdAudio, GustokoAbestiak, GustokoPodcast, TopEntzundakoak)
    SELECT IdAudio, SUM(GustokoAbestiak), SUM(GustokoPodcast), SUM(TopEntzundakoak)
    FROM estatistikakEgunero
    WHERE eguna BETWEEN lehen_date AND azken_date
    GROUP BY IdAudio;
END;
//

-- Urtea amaitzerakoan, datu guztiak sartuko dira.
DELIMITER //
-- estatistikakUrtean tauletan txertatu.
CREATE EVENT insert_estatistikakUrtean
ON SCHEDULE EVERY 1 YEAR
STARTS '2024-05-06 00:00:00'
DO
BEGIN
    DECLARE lehen_date DATE;
    DECLARE azken_date DATE;
    
    -- Urtearen hasierako data lortu eta gorde.
    SET lehen_date = DATE_FORMAT(CURRENT_DATE(), '%Y-%m-%D');
    
    -- Urtearen azken data lortu eta gorde.
    SET azken_date = DATE_FORMAT(CURRENT_DATE(), '%Y-%m-%D');

    -- estatistikakUrtean tauletan datuak sartu.
    INSERT INTO estatistikakUrtean (IdAudio, GustokoAbestiak, GustokoPodcast, TopEntzundakoak)
    SELECT IdAudio, SUM(GustokoAbestiak), SUM(GustokoPodcast), SUM(TopEntzundakoak)
    FROM estatistikakHilabetean
    WHERE eguna BETWEEN lehen_date AND azken_date
    GROUP BY IdAudio;
END;
//

-- Egun bakoitzean, totala taula beteko da.
DELIMITER //
CREATE EVENT estadistikakTotala_insert
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    CALL estadistikakTotalaBete();
END;
//

DELIMITER //
CREATE PROCEDURE estadistikakTotalaBete()
BEGIN
    DECLARE id_exist INT;

    SELECT COUNT(*) INTO id_exist
    FROM estatistikakTotalak
    WHERE IdAudio = (SELECT IdAudio FROM estatistikakEgunero WHERE eguna = CURDATE() LIMIT 1);

    IF id_exist > 0 THEN
        UPDATE estatistikakTotalak t
        JOIN (SELECT IdAudio, SUM(GustokoAbestiak) as GustokoAbestiak, SUM(GustokoPodcast) as GustokoPodcast, SUM(TopEntzundakoak) as TopEntzundakoak
              FROM estatistikakEgunero
              WHERE eguna = CURDATE()
              GROUP BY IdAudio) e
        ON t.IdAudio = e.IdAudio
        SET t.GustokoAbestiak = t.GustokoAbestiak + e.GustokoAbestiak,
            t.GustokoPodcast = t.GustokoPodcast + e.GustokoPodcast,
            t.TopEntzundakoak = t.TopEntzundakoak + e.TopEntzundakoak;
    
    -- Si el IdAudio no existe, realizar un INSERT
    ELSE
        INSERT INTO estatistikakTotalak (IdAudio, GustokoAbestiak, GustokoPodcast, TopEntzundakoak)
        SELECT IdAudio, SUM(GustokoAbestiak), SUM(GustokoPodcast), SUM(TopEntzundakoak)
        FROM estatistikakEgunero
        WHERE eguna = CURDATE()
        GROUP BY IdAudio;
    END IF;
END;
//


