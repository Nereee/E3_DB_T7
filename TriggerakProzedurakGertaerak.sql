USE db_JPamt7;

-- ----------------------------------------------------------------------------------- Premium trigger-ak -----------------------------------------------------------------------------------


-- Premium erabiltzaile bat sortzean, automatikoki premium taulan sartuko da.
DROP TRIGGER IF EXISTS PremiumTaulaBete;
DELIMITER //

CREATE TRIGGER PremiumTaulaBete
AFTER INSERT ON bezeroa
FOR EACH ROW
BEGIN
    DECLARE v_IDBezeroa VARCHAR(32);
    DECLARE v_mota ENUM('Premium', 'Free');
    DECLARE v_aktiboa TINYINT(1);
    DECLARE CONTINUE HANDLER FOR 1062
    BEGIN
        -- Log the duplicate key error
        INSERT INTO error_log (error_message, error_time)
        VALUES ('Errorea, gako hori sartuta dago Premium taulen barruan', NOW());
    END;

    -- Get the new values from the inserted row
    SET v_IDBezeroa = NEW.IDBezeroa;
    SET v_mota = NEW.mota;
    SET v_aktiboa = NEW.Aktiboa;

    -- Check if the conditions are met and insert into the premium table
    IF v_mota = 'Premium' AND v_aktiboa = TRUE THEN
        INSERT INTO premium (IDBezeroa, Iraungitze_data)
        VALUES (v_IDBezeroa, DATE_ADD(CURDATE(), INTERVAL 1 YEAR));
    END IF;
END;
//


-- Bezeroa bere kontua desaktibatzean, premium tauletik kendu
DROP TRIGGER IF EXISTS PremiumTauletikKenduTrigger;
DELIMITER //
CREATE TRIGGER PremiumTauletikKenduTrigger
AFTER UPDATE ON bezeroa
FOR EACH ROW
BEGIN
    DECLARE v_IDBezeroa VARCHAR(32);
    DECLARE v_mota ENUM('Premium','Free');
    DECLARE v_aktiboa TINYINT(1);

    DECLARE CONTINUE HANDLER FOR 1451
    BEGIN
        -- Handle foreign key constraint error
        INSERT INTO error_log (error_message, error_time)
        VALUES ('Ezin da datua aldatu edo ezabatu gakoaren murrizketak huts egiten duelako', NOW());
    END;

    SET v_IDBezeroa = NEW.IDBezeroa;
    SET v_mota = NEW.mota;
    SET v_aktiboa = NEW.Aktiboa;

    IF v_mota = 'Premium' AND v_aktiboa = 0 THEN
        DELETE FROM premium WHERE IDBezeroa = v_IDBezeroa;
    END IF;
END;
//

-- Bezeroa bere mota aldatzen badu PREMIUM erosi eta gero, premium taula barruan sartuko da.
DROP TRIGGER IF EXISTS PremiumTauletanSartu;
DELIMITER //
CREATE TRIGGER PremiumTauletanSartu
AFTER UPDATE ON bezeroa
FOR EACH ROW
BEGIN
    DECLARE v_IDBezeroa VARCHAR(32);
    DECLARE v_mota ENUM('Premium','Free');
    DECLARE v_aktiboa TINYINT(1);

    DECLARE CONTINUE HANDLER FOR 1062 
    BEGIN
        -- Handle duplicate key error
        INSERT INTO error_log (error_message, error_time)
        VALUES ('Errorea, gako hori sartuta dago Premium taulen barruan', NOW());
    END;

    SET v_IDBezeroa = NEW.IDBezeroa;
    SET v_mota = NEW.mota;
    SET v_aktiboa = NEW.Aktiboa;

    IF v_mota = 'Premium' AND v_aktiboa = 1 AND OLD.mota = 'Free' THEN
        INSERT INTO premium (IDBezeroa, ExpirationDate) VALUES (v_IDBezeroa, DATE_ADD(CURDATE(), INTERVAL 1 YEAR));
    END IF;
END;
//

DROP EVENT IF EXISTS PremiumDataMezua;
-- Bi egun amaitu baino lehenago, erabiltzailea beste tauletatik sartuko da eta mezu bat jasoko du.
DELIMITER $$
CREATE EVENT PremiumDataMezua ON SCHEDULE
EVERY 1 DAY STARTS CURRENT_TIMESTAMP()
DO
BEGIN

	DECLARE v_IraungitzeData date;
	DECLARE v_IDBezeroa varchar(32);
	DECLARE amaiera bool default 0;
    
	
    
	DECLARE c CURSOR FOR
	SELECT Iraungitze_data, IDBezeroa
	FROM premium
	WHERE Iraungitze_data < date_sub(curdate(), interval 2 day);
    
	DECLARE CONTINUE HANDLER FOR NOT FOUND
	SET amaiera = 1;
    OPEN c;
    
	WHILE amaiera = 0 DO
		FETCH c INTO v_IraungitzeData, v_IDBezeroa;
			INSERT INTO MezuaErabiltzaileak VALUES (v_IDBezeroa, concat("Kontuz, zure premium kontua amaituko da: ", v_IraungitzeData, " egunetan, errenobatu edo amaitu"));
    END WHILE;
    CLOSE c;

END;
$$

DROP EVENT IF EXISTS PremiumTauletatikKendu;
-- Data pasatzen bada eta erabiltzailea ez badu erosten berriro PREMIUM, mezu tauletatik eta premium tauletatik kenduko da.
DELIMITER $$
CREATE EVENT PremiumTauletatikKendu ON SCHEDULE
EVERY 1 DAY STARTS CURRENT_TIMESTAMP()
DO
BEGIN

	DECLARE v_IDBezeroa varchar(32);
	DECLARE amaiera bool default 0;
	#DECLARE CONTINUE HANDLER FOR 1451
	#SELECT 'Ezin da datua aldatu edo ezabatu gakoaren murrizketak huts egiten duelako';
	DECLARE c CURSOR FOR
		SELECT IDBezeroa 
		FROM premium
		WHERE Iraungitze_data < date_add(curdate(), interval 2 day);
	DECLARE CONTINUE HANDLER FOR NOT FOUND
    OPEN c;
	SET amaiera = 1;
		WHILE amaiera = 0 DO
			FETCH c INTO v_IDBezeroa;
				DELETE FROM premium WHERE IDBezeroa = v_IDBezeroa;
				DELETE FROM MezuaErabiltzaileak WHERE IDBezeroa = v_IDBezeroa;
		END WHILE;
    CLOSE c;
end;
$$

-- ----------------------------------------------------------------------------------- Estatistikak erreprodukzioak -----------------------------------------------------------------------------------

-- SHOW EVENTS;

DROP TRIGGER IF EXISTS estatistikakEguneroErreprodukzioa;
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
    IF audio_kop > 0 THEN   
        UPDATE estatistikakEgunero
        SET TopEntzundakoak = TopEntzundakoak + 1
        WHERE IdAudio = NEW.IdAudio AND eguna = DATE(NEW.erreprodukzio_data);
    ELSE
        INSERT INTO estatistikakEgunero (IdAudio, eguna, GustokoAbestiak, GustokoPodcast, TopEntzundakoak)
        VALUES (NEW.IdAudio, DATE(NEW.erreprodukzio_data), 0, 0, 1); 
    END IF;
END;
// 

DROP EVENT IF EXISTS estatistikakEguneroGustukoakGertaera;
DELIMITER //
-- Egunean behin egiten den gertaera, eguneroGustoko estatistika betetzeko.
CREATE EVENT estatistikakEguneroGustukoakGertaera
ON SCHEDULE EVERY 1 DAY
DO
BEGIN
    CALL estatistikakEguneroGustukoak();
END;
//

DROP PROCEDURE IF EXISTS estatistikakEguneroGustukoak;
DELIMITER //
-- Estatistikak gustukoak
CREATE PROCEDURE estatistikakEguneroGustukoak()
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

DROP EVENT IF EXISTS insert_estatistikakAstean;
-- Astean behin, datu osoak beteko dira.
DELIMITER //
-- estatistikakAstean tauletan txertatu.
CREATE EVENT insert_estatistikakAstean
ON SCHEDULE EVERY 1 WEEK
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

DROP EVENT IF EXISTS insert_estatistikakHilabetean;
-- Berdina baina hilabetea bukatzean, datu gustiak beteko dira.
DELIMITER //
-- estatistikakHilabetean tauletan txertatu.
CREATE EVENT insert_estatistikakHilabetean
ON SCHEDULE EVERY 1 MONTH
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


DROP EVENT IF EXISTS insert_estatistikakUrtean_gertaera;
-- Urtea amaitzerakoan, datu guztiak sartuko dira.
DELIMITER //
-- estatistikakUrtean tauletan txertatu.
CREATE EVENT insert_estatistikakUrtean_gertaera
ON SCHEDULE EVERY 1 YEAR
STARTS '2024-05-06 00:00:00'
DO
BEGIN
	CALL insert_estatistikakUrtean();
END;
//

DROP PROCEDURE IF EXISTS insert_estatistikakUrtean;
DELIMITER //
CREATE PROCEDURE insert_estatistikakUrtean()
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

DROP EVENT IF EXISTS estadistikakTotala_insert;
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

DROP PROCEDURE IF EXISTS estadistikakTotalaBete;
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
    
    ELSE
        INSERT INTO estatistikakTotalak (IdAudio, GustokoAbestiak, GustokoPodcast, TopEntzundakoak)
        SELECT IdAudio, SUM(GustokoAbestiak), SUM(GustokoPodcast), SUM(TopEntzundakoak)
        FROM estatistikakEgunero
        WHERE eguna = CURDATE()
        GROUP BY IdAudio;
    END IF;
END;
//







