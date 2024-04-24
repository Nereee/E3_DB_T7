-- ALBUM
INSERT INTO ALBUM (Izenburua, Urtea, Generoa, IDMusikaria) VALUES
('El Mal Querer', '2018-11-02', 'Flamenco', '1'),
('Motomami', '2022-03-18', 'Flamenco', '1'),
('YHLQMDLG', '2020-02-29', 'Reggaeton', '2'),
('Un verano sin ti', '2020-02-29', 'Reggaeton', '2'),
('Colores', '2020-03-19', 'Reggaeton', '3'),
('Vibras', '2018-05-25', 'Reggaeton', '3'),
('Fine Line', '2019-12-13', 'Pop', '4'),
('Harrys house', '2022-05-20', 'Pop', '4'),
('Folklore', '2020-07-24', 'Pop', '5'),
('Red', '2012-10-22', 'Country pop', '5'),
('Papi Juancho', '2020-08-21', 'Reggaeton', '6'),
('11:11', '2019-05-17', 'Reggaeton', '6'),
('Origins', '2018-11-09', 'Pop rock', '7'),
('Evolve', '2017-06-23', 'Pop rock', '7'),
('Jordi', '2021-06-11', 'Pop rock', '8'),
('V', '2014-08-29', 'Pop rock', '8'),
('Everyday Life', '2019-11-22', 'Rock alternativo', '9'),
('A Head Full of Dreams', '2015-12-04', 'Pop rock', '9');


-- PODCAST
INSERT INTO PODCAST (Kolaboratzaileak, IDPodcaster)
VALUES
('Grefg', '1'),
('Alvaro845', '2');

-- ABESTIA
INSERT INTO ABESTIA (IdAudio, IdAlbum)
VALUES
('1', '1'), 
('2', '1'), 
('3', '1'),
('4', '2'), 
('5', '2'), 
('6', '2'),
('7', '3'), 
('8', '3'), 
('9', '3'),
('10', '4'), 
('11', '4'), 
('12', '4'),
('13', '5'), 
('14', '5'), 
('15', '5'),
('16', '6'), 
('17', '6'), 
('18', '6'),
('19', '7'), 
('20', '7'), 
('21', '7'),
('22', '8'), 
('23', '8'), 
('24', '8'),
('25', '9'), 
('26', '9'), 
('27', '9'),
('28', '10'), 
('29', '10'), 
('30', '10'),
('31', '11'), 
('32', '11'), 
('33', '11'),
('34', '12'), 
('35', '12'), 
('36', '12'),
('37', '13'), 
('38', '13'), 
('39', '13'),
('40', '14'), 
('41', '14'), 
('42', '14'),
('43', '15'), 
('44', '15'), 
('45', '15'),
('46', '16'), 
('47', '16'), 
('48', '16'),
('49', '17'), 
('50', '17'), 
('51', '17'),
('52', '18'), 
('53', '18'), 
('54', '18');

-- PLAYLIST
INSERT INTO PLAYLIST (Izenburua, Sorrera_data, IDBezeroa)
VALUES
('Playlist 1', '2023-04-01', 'juanperez&'),
('Playlist 2', '2023-05-10', 'mariagonzalez&'),
('Playlist 3', '2023-07-20', 'mariagonzalez&'),
('Playlist 4', '2023-08-05', 'analopez&'),
('Playlist 5', '2023-09-15', 'davidmartinez&');

-- PLAYLIST_ABESTIAK
INSERT INTO PLAYLIST_ABESTIAK (IDList, IdAudio)
VALUES
(1, '40'),
(1, '23'),
(2, '33'),
(2, '32'),
(3, '18'),
(4, '4'),
(4, '25'),
(5, '13'),
(5, '53');

-- GUSTUKOAK
INSERT INTO GUSTUKOAK (IDBezeroa, IdAudio)
VALUES
('juanperez&', '43'),
('juanperez&', '16'),
('mariagonzalez&', '35'),
('mariagonzalez&', '41'),
('analopez&', '21'),
('analopez&', '8'),
('davidmartinez&', '11'),
('davidmartinez&', '1'),
('elenafdez&', '2'),
('elenafdez&', '12');

-- ERREPRODUKZIOA
INSERT INTO ERREPRODUKZIOAK (IDBezeroa, IdAudio, erreprodukzio_data)
VALUES
('juanperez&', '23', '2023-04-02'),
('mariagonzalez&', '50', '2023-05-12'),
('analopez&', '21', '2023-07-21'),
('davidmartinez&', '31', '2023-08-06'),
('davidmartinez&', '39', '2023-09-16');

