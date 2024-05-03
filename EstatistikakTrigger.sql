-- Estatistikak erreprodukzioak
DELIMITER //
CREATE TRIGGER estatistikakEguneroErreprodukzioa
AFTER INSERT ON erreprodukzioak
FOR EACH ROW
BEGIN
    DECLARE audio_count INT;
SELECT 
    COUNT(*)
INTO audio_count FROM
    estatistikakEgunero
WHERE
    IdAudio = NEW.IdAudio
        AND eguna = DATE(NEW.erreprodukzio_data);
    if audio_count > 0 THEN   
        UPDATE estatistikakEgunero
        SET TopEntzundakoak = TopEntzundakoak + 1
        WHERE IdAudio = NEW.IdAudio AND eguna = DATE(NEW.erreprodukzio_data);
    else
        insert into estatistikakEgunero (IdAudio, eguna, GustokoAbestiak, GustokoPodcast, TopEntzundakoak)
        values (NEW.IdAudio, DATE(NEW.erreprodukzio_data), 0, 0, 1); 
    END IF;
END;

-- Estatistikak gustukoak
CREATE TRIGGER estatistikakEguneroGustukoak
AFTER INSERT ON erreprodukzioak
FOR EACH ROW
BEGIN
    DECLARE audio_count INT;
SELECT 
    COUNT(*)
INTO audio_count FROM
    estatistikakEgunero
WHERE
    IdAudio = NEW.IdAudio
        AND eguna = DATE(NEW.erreprodukzio_data);
    if audio_count > 0 THEN   
        UPDATE estatistikakEgunero
        SET TopEntzundakoak = TopEntzundakoak + 1
        WHERE IdAudio = NEW.IdAudio AND eguna = DATE(NEW.erreprodukzio_data);
    else
        insert into estatistikakEgunero (IdAudio, eguna, GustokoAbestiak, GustokoPodcast, TopEntzundakoak)
        values (NEW.IdAudio, DATE(NEW.erreprodukzio_data), 0, 0, 1); 
    END IF;
END;

-- insertar estatistikakAstean
CREATE EVENT insert_estatistikakAstean
ON SCHEDULE EVERY 1 WEEK
STARTS 'YYYY-MM-DD 00:00:00'
DO
BEGIN
    DECLARE lehen_date DATE;
    DECLARE azken_date DATE;
    
    -- Obtener la fecha de inicio de la semana (lunes)
    SET lehen_date = DATE_SUB(CURRENT_DATE(), INTERVAL WEEKDAY(CURRENT_DATE()) DAY);
    
    -- Obtener la fecha de fin de la semana (domingo)
    SET azken_date = DATE_ADD(lehen_date, INTERVAL 6 DAY);

    -- Insertar los datos de la semana cerrada en estatistikakAstean
    INSERT INTO estatistikakAstean (IdAudio, GustokoAbestiak, GustokoPodcast, TopEntzundakoak)
    SELECT IdAudio, SUM(GustokoAbestiak), SUM(GustokoPodcast), SUM(TopEntzundakoak)
    FROM estatistikakEgunero
    WHERE eguna BETWEEN lehen_date AND azken_date
    GROUP BY IdAudio;
END;

CREATE EVENT insert_estatistikakHilabetean
ON SCHEDULE EVERY 1 MONTH
STARTS 'YYYY-MM-01 00:00:00'
DO
BEGIN
    DECLARE lehen_date DATE;
    DECLARE azken_date DATE;
    
    -- Obtener la fecha de inicio del mes
    SET lehen_data = DATE_FORMAT(CURRENT_DATE(), '%Y-%m-01');
    
    -- Obtener la fecha de fin del mes
    SET azken_data = LAST_DAY(lehen_data);

    -- Insertar los datos del mes en estatistikakHilabetean
    INSERT INTO estatistikakHilabetean (IdAudio, GustokoAbestiak, GustokoPodcast, TopEntzundakoak)
    SELECT IdAudio, SUM(GustokoAbestiak), SUM(GustokoPodcast), SUM(TopEntzundakoak)
    FROM estatistikakEgunero
    WHERE eguna BETWEEN lehen_data AND azken_data
    GROUP BY IdAudio;
END;

CREATE EVENT insert_estatistikakUrtean
ON SCHEDULE EVERY 1 YEAR
STARTS 'YYYY-01-01 00:00:00'
DO
BEGIN
    DECLARE lehen_date DATE;
    DECLARE azken_date DATE;
    
    -- Obtener la fecha de inicio del año
    SET lehen_date = DATE_FORMAT(CURRENT_DATE(), '%Y-01-01');
    
    -- Obtener la fecha de fin del año
    SET azken_date = DATE_FORMAT(CURRENT_DATE(), '%Y-12-31');

    -- Insertar los datos del año en estatistikakUrtean
    INSERT INTO estatistikakUrtean (IdAudio, GustokoAbestiak, GustokoPodcast, TopEntzundakoak)
    SELECT IdAudio, SUM(GustokoAbestiak), SUM(GustokoPodcast), SUM(TopEntzundakoak)
    FROM estatistikakHilabetean
    WHERE eguna BETWEEN lehen_date AND azken_date
    GROUP BY IdAudio;
END;

//
