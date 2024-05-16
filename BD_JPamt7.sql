DROP DATABASE IF EXISTS db_JPamt7;

CREATE DATABASE	IF NOT EXISTS db_JPamt7
CHARACTER SET utf8 COLLATE utf8mb3_general_ci;

USE db_JPamt7;

CREATE TABLE musikaria(
	IDMusikaria int auto_increment,
	IzenArtistikoa varchar(30) not null unique,
	Irudia blob,
	Ezaugarria enum("Bakarlaria", "Taldea") not null,
    Deskribapena varchar(1000) not null,
	Primary key (IDMusikaria) 
);

CREATE TABLE podcaster (
	IDPodcaster int auto_increment,
	IzenArtistikoa varchar(30) not null unique,
	Irudia blob,
	Deskribapena varchar(1000) not null,
	Primary key (IDPodcaster)
);

CREATE TABLE hizkuntza (
	IdHizkuntza enum("ES","EU","EN","FR","DE","CA","GA","AR") not null,
	Deskribapena varchar(100) not null,
	Primary key (IdHizkuntza)
);

CREATE TABLE bezeroa  (
	IDBezeroa varchar(32),
	Izena varchar(30) not null,
	Abizena varchar(30) not null,
	Hizkuntza enum("ES","EU","EN","FR","DE","eCA","GA","AR"),
	Erabiltzailea varchar(30) not null unique,
	Pasahitza varchar(30)  not null,
	Jaiotza_data date not null,
	Erregistro_data date not null,
    Aktiboa boolean default true,
	Mota enum("Premium", "Free") not null default ("Free"),
	Primary key (IDBezeroa),
    Constraint hizkuntza_fk1 foreign key(Hizkuntza) references hizkuntza (IdHizkuntza) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE MezuaErabiltzaileak (
	IDBezeroa varchar(32),
	Mezua varchar(30),
    
	Primary key (IDBezeroa, Mezua),
    Foreign key (IDBezeroa) references bezeroa (IDBezeroa)
);

CREATE TABLE premium (
	IDBezeroa varchar(32),
	Iraungitze_data date not null,
	Primary key (IDBezeroa),
    Constraint IDBezeroa_fk1 foreign key(IDBezeroa) references bezeroa (IDBezeroa) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE audio  (
	IdAudio int auto_increment,
	Izena varchar(30) not null,
	Irudia longblob,
    Iraupena time not null,
	Mota enum("Podcasta ","Abestia") not null,
	Constraint IdAudio_pk1 Primary key (IdAudio)
);

CREATE TABLE album   (
	IdAlbum int auto_increment,
	Izenburua varchar(30) not null,
	Urtea date not null,
	Generoa varchar(30) not null,
	IDMusikaria int not null, 
	Primary key (IdAlbum) ,
    Constraint IDMusikaria_fk1 foreign key(IDMusikaria) references musikaria (IDMusikaria)  ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE podcast  (
	IdAudio int auto_increment, 
	Kolaboratzaileak varchar(255),
	IDPodcaster int not null, 
	Primary key (IdAudio),
    Constraint IdAudio_fk1 foreign key(IdAudio) references audio (IdAudio) ON DELETE CASCADE ON UPDATE CASCADE,
	Constraint IDPodcaster_fk1 foreign key(IDPodcaster) references podcaster (IDPodcaster) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE abestia  (
	IdAudio int,
	IdAlbum int not null, 
	Primary key (IdAudio),
    Constraint IdAudio_fk2 foreign key(IdAudio) references audio (IdAudio) ON DELETE CASCADE ON UPDATE CASCADE,
    Constraint IdAlbum_fk1 foreign key(IdAlbum) references album (IdAlbum)  ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE playlist    (
	IDList int auto_increment, 
	Izenburua varchar(30) not null,
	Sorrera_data date not null,
	IDBezeroa varchar(32),
	Primary key (IDList),
    Constraint IDBezeroa_fk2 foreign key(IDBezeroa) references bezeroa (IDBezeroa) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE playlist_abestiak    (
	IDList int, 
	IdAudio int,
	Primary key (IDList,IdAudio),
    Constraint IDList_fk1 foreign key(IDList) references playlist (IDList) ON DELETE CASCADE ON UPDATE CASCADE,
    Constraint IdAudio_fk3 foreign key(IdAudio) references audio (IdAudio) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE gustukoak(
	IDBezeroa varchar(32),
	IdAudio int,
	Primary key (IDBezeroa,IdAudio),
    Constraint IDBezeroa_fk3 foreign key(IDBezeroa) references bezeroa (IDBezeroa) ON DELETE CASCADE ON UPDATE CASCADE,
    Constraint IdAudio_fk4 foreign key(IdAudio) references audio (IdAudio) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE erreprodukzioak(
    IDerreprodukzioak int auto_increment,
    IDBezeroa varchar(32),
    IdAudio int,
    erreprodukzio_data time not null,
    Primary key (IDerreprodukzioak),
    Constraint IDBezeroa_fk4 foreign key(IDBezeroa) references bezeroa (IDBezeroa) ON UPDATE CASCADE,
    Constraint IdAudio_fk5 foreign key(IdAudio) references audio (IdAudio) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE estatistikakEgunero (
    IdAudio int,
    eguna date,
    GustokoAbestiak int,
    GustokoPodcast int,
    TopEntzundakoak int,
    primary key(eguna,IDAudio),
    foreign key (IDAudio) references audio (IdAudio) ON DELETE CASCADE
);

CREATE TABLE estatistikakAstean (
    IdAudio int,
    IDEstastean int auto_increment,
    eguna date,
    GustokoAbestiak int,
    GustokoPodcast int,
    TopEntzundakoak int,
    primary key(IDEstastean),
    foreign key (IDAudio) references audio (IdAudio) ON DELETE CASCADE
);

CREATE TABLE estatistikakHilabetean (
    IdAudio int,
    IDEsthilabetean int auto_increment,
    eguna date,
    GustokoAbestiak int,
    GustokoPodcast int,
    TopEntzundakoak int,
    primary key (IDEsthilabetean),
    foreign key (IDAudio) references audio (IdAudio) ON DELETE CASCADE
);

CREATE TABLE estatistikakUrtean (
    IdAudio int,
    IDEsturtean int auto_increment,
    eguna date,
    GustokoAbestiak int,
    GustokoPodcast int,
    TopEntzundakoak int,
    primary key (IDEsturtean),
    foreign key (IDAudio) references audio (IdAudio) ON DELETE CASCADE
);

CREATE TABLE estatistikakTotalak (
    IdAudio int,
    IDEsttotala int auto_increment,
    GustokoAbestiak int,
    GustokoPodcast int,
    TopEntzundakoak int,
    primary key (IDEsttotala),
    foreign key (IDAudio) references audio (IdAudio) ON DELETE CASCADE
);
CREATE TABLE error_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    error_mezua VARCHAR(255),
    error_denbora DATETIME
);
-- ----------------------------------------------------------------------------------- Indixeak -----------------------------------------------------------------------------------

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

-- Izenburuaren bidez album-a bilatu.
CREATE INDEX indx_albumIzenburua ON album (Izenburua);

-- Playlist izen eta idAudio bidez bilatu.
CREATE INDEX idx_plalist_Izenburua ON playlist (Izenburua);
CREATE INDEX indx_playlist_audioa ON playlist_abestiak (IdAudio);

-- ----------------------------------------------------------------------------------- Bistak -----------------------------------------------------------------------------------

-- Podcast eta abestiaren datu interesgarriak irazkutzeko (izena, album izena, artista eta iraupena)
CREATE OR REPLACE VIEW AbestiInformazioa
AS 
SELECT audio.izena AS "Abesti izena", album.izenburua AS "Izenburua", musikaria.IzenArtistikoa AS "Artista izena", audio.Iraupena AS "Iraupena", IdAudio
    FROM abestia JOIN audio using (IdAudio)
				JOIN album USING (IdAlbum)
                JOIN musikaria USING (IDMusikaria);


CREATE OR REPLACE VIEW PodcastInformazioa
AS 
SELECT audio.izena as "Izena", podcast.Kolaboratzaileak AS "Kolaboratzaileak", podcaster.IzenArtistikoa AS "Artista", audio.Iraupena AS "Iraupena"
    FROM podcast JOIN audio using (IdAudio)
				 JOIN podcaster USING (IDPodcaster);
			
            
-- Zenbat bezero eta horietako zeinek PREMIUM ordaintzen dute 
CREATE OR REPLACE VIEW BezeroEtaPremiumKopurua
AS
SELECT count(bezeroa.IDBezeroa) AS "Bezero Kopurua", count(premium.IDBezeroa) AS "Premium Kantitatea"
    FROM bezeroa LEFT JOIN premium using(IDBezeroa);
   
-- Musikariek zenbat erreproduzio TOTALAK dituzte.
CREATE OR REPLACE VIEW musikaria_erreprodukzioak
AS 
SELECT m.IzenArtistikoa AS IzenArtistikoa, SUM(es.TopEntzundakoak) AS Totala
	FROM musikaria m LEFT JOIN album a using (IDMusikaria)
		LEFT JOIN abestia ab  using (IdAlbum)
        LEFT JOIN estatistikakTotalak es using (IDAudio)
	GROUP BY 1;
    
-- Podcaster-ek zenbat erreproduzio TOTALAK dituzte.
CREATE OR REPLACE VIEW podcaster_erreprodukzioak
AS 
SELECT IzenArtistikoa AS Podcaster, SUM(es.TopEntzundakoak) AS Totala
	FROM podcaster p LEFT JOIN podcast pd using (IDPodcaster)
        LEFT JOIN estatistikakTotalak es using (IDAudio)
	GROUP BY 1; 

--  Musikariaren arabera, abestiak atera.
CREATE OR REPLACE VIEW musikari_abestiak
AS
SELECT IdAudio, Izena, Iraupena, count(IdAudio), Izenburua
	FROM audio a  JOIN abestia USING (IdAudio) 
		 JOIN album USING (IdAlbum) 
	GROUP BY 1,2,3;
    
-- Playlist izena, id-a, horietako bezeroa eta zenbat abesti daukan.
CREATE OR REPLACE VIEW playlistInfoKop
AS 
SELECT p.IDList, p.Izenburua, p.IDBezeroa, count(pa.IdAudio) as Kapazitatea, Sorrera_data
	FROM playlist p 
		LEFT JOIN playlist_abestiak pa using (IDList)
	GROUP BY 1,2,3;

-- Playlist bakoitzaren abestia informazioa.
CREATE OR REPLACE VIEW playlistAbestiakInfo 
AS
SELECT `Abesti izena` AS abestiIzena, a.Irudia, a.IdAudio, ab.Izenburua AS albumIzena, `Artista izena` AS artistaIzena, alb.Generoa as albumGeneroa, 
							a.Iraupena AS iraupena, IDList, p.Izenburua AS playlistIzena, Sorrera_data AS "albumUrtea"
	FROM playlist p
		JOIN playlist_abestiak pa USING (IDList) 
		JOIN audio a USING (IdAudio) 
        JOIN abestia abe USING (IdAudio)
        JOIN album alb USING (IdAlbum)
		JOIN AbestiInformazioa ab USING(IdAudio);

-- Playlist bakoitzean dagoen abesti kopurua
CREATE OR REPLACE VIEW playlistAbestiKop 
AS
SELECT play.Izenburua, play.IDList, count(pb.IdAudio) as Kopurua
	FROM playlist play 
		JOIN playlist_abestiak pb USING (IDList)
	GROUP BY 1,2
ORDER BY 3 DESC;

CREATE OR REPLACE VIEW ArtistenAbestiak 
AS
SELECT Izenburua,  year(Urtea) as urtea, count(IdAudio) AS kapazitatea, Generoa, IzenArtistikoa FROM  album al 
						LEFT JOIN abestia ab USING (IdAlbum) 
                        JOIN musikaria m USING (IDMusikaria) 
                        where IzenArtistikoa = "Rosalía"
                        group by 1, 2, 4;

