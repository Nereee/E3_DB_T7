drop database if exists db_JPamt7;

create database	if not exists db_JPamt7
CHARACTER SET utf8 COLLATE utf8mb3_general_ci;

use db_JPamt7;

create table MUSIKARIA(
	IDMusikaria int auto_increment,
	IzenArtistikoa varchar(30) not null unique,
	Irudia blob,
	Ezaugarria enum("Bakarlaria", "Taldea") not null,
    Deskribapena varchar(255) not null,
	Constraint IDMusikaria_pk1 Primary key (IDMusikaria) 
);

create table PODCASTER (
	IDPodcaster int auto_increment,
	IzenArtistikoa varchar(30) not null unique,
	Irudia blob,
	Deskribapena varchar(255) not null,
	Constraint IDPodcaster_pk1 Primary key (IDPodcaster)
);
create table HIZKUNTZA (
	IdHizkuntza enum("ES","EU","EN","FR","DE","CA","GA","AR") not null,
	Deskribapena varchar(100) not null,
	Constraint IdHizkuntza_pk1 Primary key (IdHizkuntza)
);
create table BEZEROA   (
	IDBezeroa varchar(32),
	Izena varchar(30) not null,
	Abizena varchar(30) not null,
	Hizkuntza enum("ES","EU","EN","FR","DE","eCA","GA","AR"),
	Erabiltzailea varchar(30) not null unique,
	Pasahitza varchar(30)  not null,
	Jaiotza_data date not null,
	Erregistro_data date not null,
	Mota enum("Premium", "Free") not null default ("Free"),
	Constraint IDBezeroa_pk1 Primary key (IDBezeroa),
    Constraint hizkuntza_fk1 foreign key(Hizkuntza) references HIZKUNTZA (IdHizkuntza) ON UPDATE CASCADE ON DELETE SET NULL
);

create table PREMIUM (
	IDBezeroa varchar(32),
	Iraungitze_data date not null,
	Constraint IDBezeroa_pk2 Primary key (IDBezeroa),
    Constraint IDBezeroa_fk1 foreign key(IDBezeroa) references BEZEROA (IDBezeroa) ON DELETE CASCADE ON UPDATE CASCADE
);

create table AUDIO  (
	IdAudio int auto_increment,
	Izena varchar(30) not null,
	Irudia blob,
    Iraupena time not null,
	Mota enum("Podcasta ","Abestia") not null,
	Constraint IdAudio_pk1 Primary key (IdAudio)
);

create table ALBUM   (
	IdAlbum int auto_increment,
	Izenburua varchar(30) not null,
	Urtea date not null,
	Generoa varchar(30) not null,
	IDMusikaria int not null, 
	Constraint IdAlbum_pk1 Primary key (IdAlbum) ,
    Constraint IDMusikaria_fk1 foreign key(IDMusikaria) references MUSIKARIA (IDMusikaria)  ON DELETE CASCADE ON UPDATE CASCADE
);

create table PODCAST  (
	IdAudio int auto_increment, 
	Kolaboratzaileak varchar(255),
	IDPodcaster int not null, 
	Constraint IdAudio_pk1 Primary key (IdAudio),
    Constraint IdAudio_fk1 foreign key(IdAudio) references AUDIO (IdAudio) ON DELETE CASCADE ON UPDATE CASCADE,
	Constraint IDPodcaster_fk1 foreign key(IDPodcaster) references PODCASTER (IDPodcaster) ON UPDATE CASCADE ON DELETE CASCADE
);

create table ABESTIA  (
	IdAudio int,
	IdAlbum int not null, 
	Constraint IdAudio_Pk2 Primary key (IdAudio),
    Constraint IdAudio_fk2 foreign key(IdAudio) references AUDIO (IdAudio) ON DELETE CASCADE ON UPDATE CASCADE,
    Constraint IdAlbum_fk1 foreign key(IdAlbum) references ALBUM (IdAlbum)  ON DELETE CASCADE ON UPDATE CASCADE
);

create table PLAYLIST    (
	IDList int auto_increment, 
	Izenburua varchar(30) not null,
	Sorrera_data date not null,
	IDBezeroa varchar(32),
	Constraint IDlist_pk1 Primary key (IDList),
    Constraint IDBezeroa_fk2 foreign key(IDBezeroa) references BEZEROA (IDBezeroa) ON DELETE CASCADE ON UPDATE CASCADE
);

create table PLAYLIST_ABESTIAK    (
	IDList int, 
	IdAudio int,
	Constraint IDlist_IdAudio_pk1 Primary key (IDList,IdAudio),
    Constraint IDList_fk1 foreign key(IDList) references PLAYLIST (IDList) ON DELETE CASCADE ON UPDATE CASCADE,
    Constraint IdAudio_fk3 foreign key(IdAudio) references AUDIO (IdAudio) ON UPDATE CASCADE
);

create table GUSTUKOAK(
	IDBezeroa varchar(32),
	IdAudio int,
	Constraint IDBezeroa_IdAudio_pk1 Primary key (IDBezeroa,IdAudio),
    Constraint IDBezeroa_fk3 foreign key(IDBezeroa) references BEZEROA (IDBezeroa) ON DELETE CASCADE ON UPDATE CASCADE,
    Constraint IdAudio_fk4 foreign key(IdAudio) references AUDIO (IdAudio) ON UPDATE CASCADE
);

create table ERREPRODUKZIOAK(
	IDBezeroa varchar(32),
	IdAudio int,
    erreprodukzio_data date not null,
	Constraint IDBezeroa_IdAudio_erreprodukzio_data_pk1 Primary key (IDBezeroa,IdAudio,erreprodukzio_data),
    Constraint IDBezeroa_fk4 foreign key(IDBezeroa) references BEZEROA (IDBezeroa) ON UPDATE CASCADE,
    Constraint IdAudio_fk5 foreign key(IdAudio) references AUDIO (IdAudio) ON UPDATE CASCADE
);

create table ESTATISKTIKAK(
	IDAudio int,
	Constraint IDAudio_pk3 Primary key (IDAudio),
    Constraint IdAudio_fk6 foreign key(IdAudio) references AUDIO (IdAudio) ON UPDATE CASCADE
);










