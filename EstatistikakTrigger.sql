-- Estatistikak erreprodukzioak

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

DELIMITER //
-- Estatistikak gustukoak
CREATE TRIGGER estatistikakEguneroGustukoak
AFTER INSERT ON gustokoak
FOR EACH ROW
BEGIN

DECLARE audio_kop INT;
DECLARE v_mota enum('Podcasta','Abestia');

-- Begiratu ea abesti edo podcast hori badago taulan.
SELECT COUNT(*) INTO audio_kop
FROM estatistikakEgunero
WHERE IdAudio = NEW.IdAudio AND eguna = DATE(NEW.erreprodukzio_data);
	
-- Mota berrezkuratu.
SELECT mota into v_mota
FROM audio 
WHERE IdAudio = NEW.IdAudio;

	-- Audio hori badago, update egingo da. Podcast edo abestia bada egiaztatu egingo da.
    IF audio_kop > 0 THEN   
		IF v_mota = 'Abestia' THEN
			UPDATE estatistikakEgunero
			SET GustokoAbestiak = GustokoAbestiak + 1
			WHERE IdAudio = NEW.IdAudio AND eguna = DATE(NEW.erreprodukzio_data);
		ELSE
			UPDATE estatistikakEgunero
			SET GustokoPodcast = GustokoPodcast + 1
			WHERE IdAudio = NEW.IdAudio AND eguna = DATE(NEW.erreprodukzio_data);
        END IF;
	-- Ez badago, insert bat egingo da.
    ELSE
		IF v_mota = 'Podcasta' THEN
				insert into estatistikakEgunero (IdAudio, eguna, GustokoAbestiak, GustokoPodcast, TopEntzundakoak)
				values (NEW.IdAudio, DATE(NEW.erreprodukzio_data), 0, 1, 0); 
		ELSE 
				insert into estatistikakEgunero (IdAudio, eguna, GustokoAbestiak, GustokoPodcast, TopEntzundakoak)
				values (NEW.IdAudio, DATE(NEW.erreprodukzio_data), 1, 0, 0); 
		END IF;
    END IF;
END;
//

DELIMITER //
-- estatistikakAstean tauletan txertatu.
CREATE EVENT insert_estatistikakAstean
ON SCHEDULE EVERY 1 WEEK
STARTS 'YYYY-MM-DD 00:00:00'
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

DELIMITER //
-- estatistikakHilabetean tauletan txertatu.
CREATE EVENT insert_estatistikakHilabetean
ON SCHEDULE EVERY 1 MONTH
STARTS 'YYYY-MM-01 00:00:00'
DO
BEGIN
    DECLARE lehen_date DATE;
    DECLARE azken_date DATE;
    
    -- Hilabetearen hasierako data lortu eta gorde.
    SET lehen_data = DATE_FORMAT(CURRENT_DATE(), '%Y-%m-01');
    
    -- Hilabetearen azken data lortu eta gorde.
    SET azken_data = LAST_DAY(lehen_data);

    -- estatistikakHilabetean tauletan datuak sartu.
    INSERT INTO estatistikakHilabetean (IdAudio, GustokoAbestiak, GustokoPodcast, TopEntzundakoak)
    SELECT IdAudio, SUM(GustokoAbestiak), SUM(GustokoPodcast), SUM(TopEntzundakoak)
    FROM estatistikakEgunero
    WHERE eguna BETWEEN lehen_data AND azken_data
    GROUP BY IdAudio;
END;
//

DELIMITER //
-- estatistikakUrtean tauletan txertatu.
CREATE EVENT insert_estatistikakUrtean
ON SCHEDULE EVERY 1 YEAR
STARTS 'YYYY-01-01 00:00:00'
DO
BEGIN
    DECLARE lehen_date DATE;
    DECLARE azken_date DATE;
    
    -- Urtearen hasierako data lortu eta gorde.
    SET lehen_date = DATE_FORMAT(CURRENT_DATE(), '%Y-01-01');
    
    -- Urtearen azken data lortu eta gorde.
    SET azken_date = DATE_FORMAT(CURRENT_DATE(), '%Y-12-31');

    -- estatistikakUrtean tauletan datuak sartu.
    INSERT INTO estatistikakUrtean (IdAudio, GustokoAbestiak, GustokoPodcast, TopEntzundakoak)
    SELECT IdAudio, SUM(GustokoAbestiak), SUM(GustokoPodcast), SUM(TopEntzundakoak)
    FROM estatistikakHilabetean
    WHERE eguna BETWEEN lehen_date AND azken_date
    GROUP BY IdAudio;
END;
//
