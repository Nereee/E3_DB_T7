drop database if exists db_JPamt7;

create database	if not exists db_JPamt7
CHARACTER SET utf8 COLLATE utf8mb3_general_ci;

use db_JPamt7;

create table musikaria(
	IDMusikaria int auto_increment,
	IzenArtistikoa varchar(30) not null unique,
	Irudia blob,
	Ezaugarria enum("Bakarlaria", "Taldea") not null,
    Deskribapena varchar(1000) not null,
	Primary key (IDMusikaria) 
);

create table podcaster (
	IDPodcaster int auto_increment,
	IzenArtistikoa varchar(30) not null unique,
	Irudia blob,
	Deskribapena varchar(1000) not null,
	Primary key (IDPodcaster)
);

create table hizkuntza (
	IdHizkuntza enum("ES","EU","EN","FR","DE","CA","GA","AR") not null,
	Deskribapena varchar(100) not null,
	Primary key (IdHizkuntza)
);

create table bezeroa  (
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

create table premium (
	IDBezeroa varchar(32),
	Iraungitze_data date not null,
	Primary key (IDBezeroa),
    Constraint IDBezeroa_fk1 foreign key(IDBezeroa) references bezeroa (IDBezeroa) ON DELETE CASCADE ON UPDATE CASCADE
);

create table audio  (
	IdAudio int auto_increment,
	Izena varchar(30) not null,
	Irudia longblob,
    Iraupena time not null,
	Mota enum("Podcasta ","Abestia") not null,
	Constraint IdAudio_pk1 Primary key (IdAudio)
);

create table album   (
	IdAlbum int auto_increment,
	Izenburua varchar(30) not null,
	Urtea date not null,
	Generoa varchar(30) not null,
	IDMusikaria int not null, 
	Primary key (IdAlbum) ,
    Constraint IDMusikaria_fk1 foreign key(IDMusikaria) references musikaria (IDMusikaria)  ON DELETE CASCADE ON UPDATE CASCADE
);

create table podcast  (
	IdAudio int auto_increment, 
	Kolaboratzaileak varchar(255),
	IDPodcaster int not null, 
	Primary key (IdAudio),
    Constraint IdAudio_fk1 foreign key(IdAudio) references audio (IdAudio) ON DELETE CASCADE ON UPDATE CASCADE,
	Constraint IDPodcaster_fk1 foreign key(IDPodcaster) references podcaster (IDPodcaster) ON UPDATE CASCADE ON DELETE CASCADE
);

create table abestia  (
	IdAudio int,
	IdAlbum int not null, 
	Primary key (IdAudio),
    Constraint IdAudio_fk2 foreign key(IdAudio) references audio (IdAudio) ON DELETE CASCADE ON UPDATE CASCADE,
    Constraint IdAlbum_fk1 foreign key(IdAlbum) references album (IdAlbum)  ON DELETE CASCADE ON UPDATE CASCADE
);

create table playlist    (
	IDList int auto_increment, 
	Izenburua varchar(30) not null,
	Sorrera_data date not null,
	IDBezeroa varchar(32),
	Primary key (IDList),
    Constraint IDBezeroa_fk2 foreign key(IDBezeroa) references bezeroa (IDBezeroa) ON DELETE CASCADE ON UPDATE CASCADE
);

create table playlist_abestiak    (
	IDList int, 
	IdAudio int,
	Primary key (IDList,IdAudio),
    Constraint IDList_fk1 foreign key(IDList) references playlist (IDList) ON DELETE CASCADE ON UPDATE CASCADE,
    Constraint IdAudio_fk3 foreign key(IdAudio) references audio (IdAudio) ON UPDATE CASCADE ON DELETE CASCADE
);

create table gustukoak(
	IDBezeroa varchar(32),
	IdAudio int,
	Primary key (IDBezeroa,IdAudio),
    Constraint IDBezeroa_fk3 foreign key(IDBezeroa) references bezeroa (IDBezeroa) ON DELETE CASCADE ON UPDATE CASCADE,
    Constraint IdAudio_fk4 foreign key(IdAudio) references audio (IdAudio) ON UPDATE CASCADE ON DELETE CASCADE
);

create table erreprodukzioak(
	IDerreprodukzioak int auto_increment,
	IDBezeroa varchar(32),
	IdAudio int,
    erreprodukzio_data time not null,
	Primary key (IDerreprodukzioak),
    Constraint IDBezeroa_fk4 foreign key(IDBezeroa) references bezeroa (IDBezeroa) ON UPDATE CASCADE,
    Constraint IdAudio_fk5 foreign key(IdAudio) references audio (IdAudio) ON UPDATE CASCADE
);

CREATE TABLE estatistikakEgunero (
    IdAudio int,
    eguna date ,
    GustokoAbestiak int,
    GustokoPodcast int,
    TopEntzundakoak int,
	primary key(eguna,IDAudio),
    foreign key (IDAudio) references audio (IdAudio)
);

CREATE TABLE estatistikakAstean (
    IdAudio int,
    IDEstastean int auto_increment,
    GustokoAbestiak int,
    GustokoPodcast int,
    TopEntzundakoak int,
	primary key(IDEstastean),
    foreign key (IDAudio) references audio (IdAudio)
);

CREATE TABLE estatistikakHilabetean (
    IdAudio int,
    IDEsthilabetean int auto_increment,
    GustokoAbestiak int,
    GustokoPodcast int,
    TopEntzundakoak int,
    primary key (IDEsthilabetean),
    foreign key (IDAudio) references audio (IdAudio)
);

CREATE TABLE estatistikakUrtean (
    IdAudio int,
    IDEsturtean int auto_increment,
    GustokoAbestiak int,
    GustokoPodcast int,
    TopEntzundakoak int,
    primary key (IDEsturtean),
    foreign key (IDAudio) references audio (IdAudio)
);

CREATE TABLE estatistikakTotalak (
    IdAudio int,
    IDEsttotala int auto_increment,
    GustokoAbestiak int,
    GustokoPodcast int,
    TopEntzundakoak int,
    primary key (IDEsttotala),
    foreign key (IDAudio) references audio (IdAudio)
);


-- ----------------------------------------------------------------------------------- Bistak -----------------------------------------------------------------------------------

-- Podcast eta abestiaren datu interesgarriak irazkutzeko (izena, album izena, artista eta iraupena)
CREATE OR REPLACE VIEW AbestiInformazioa
AS 
SELECT audio.izena AS "Abesti izena", album.izenburua AS "Izenburua", musikaria.IzenArtistikoa AS "Artista izena", audio.Iraupena AS "Iraupena"
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
	FROM musikaria m JOIN album a using (IDMusikaria)
		JOIN abestia ab using (IdAlbum)
        JOIN estatistikakTotalak es using (IDAudio)
	GROUP BY 1;
    
-- Podcaster-ek zenbat erreproduzio TOTALAK dituzte.
CREATE OR REPLACE VIEW podcaster_erreprodukzioak
AS 
SELECT IzenArtistikoa AS Podcaster, SUM(es.TopEntzundakoak) AS Totala
	FROM podcaster p JOIN podcast pd using (IDPodcaster)
        JOIN estatistikakTotalak es using (IDAudio)
	GROUP BY 1; 

-- 
CREATE OR REPLACE VIEW musikari_abestiak
AS
	SELECT IdAudio, Izena, Iraupena, count(IdAudio) 
		FROM audio a JOIN abestia USING (IdAudio) 
			JOIN album USING (IdAlbum) 
	GROUP BY 1,2,3;








