DROP DATABASE ucsdme;
CREATE DATABASE ucsdme;

USE ucsdme;

/*NEED THIS TO TURN ON EVENTS IN MYSQL FOR DELETING FROM facebookID*/
SET GLOBAL event_scheduler = ON;

CREATE TABLE pois
(
  poi_id    INT AUTO_INCREMENT NOT NULL,
  lat       DOUBLE NOT NULL,
  lon       DOUBLE NOT NULL,
  alt       DOUBLE NOT NULL,
  name	    varchar(255) NOT NULL,
  PRIMARY KEY (poi_id)
);

CREATE TABLE graffiti
(
  graph_id  INT AUTO_INCREMENT NOT NULL,
  lat       DOUBLE NOT NULL,
  lon       DOUBLE NOT NULL,
  picture   LONGBLOB NOT NULL,
  PRIMARY KEY (graph_id)
);

CREATE TABLE categories
(
  cat_id  INT AUTO_INCREMENT NOT NULL,
  name	  varchar(255) NOT NULL,
  PRIMARY KEY (cat_id)
);

CREATE TABLE poiToCategory
(
  poi2cat_id  INT AUTO_INCREMENT NOT NULL,
  poi_id  INT NOT NULL,
  cat_id  INT NOT NULL,
  PRIMARY KEY (poi2cat_id),
  FOREIGN KEY (poi_id) REFERENCES pois(poi_id),
  FOREIGN KEY (cat_id) REFERENCES categories(cat_id)
);

CREATE TABLE facebookID
(
  facebook_id BIGINT NOT NULL,
  name varchar(255) NOT NULL,
  lat DOUBLE NOT NULL,
  lon DOUBLE NOT NULL,
  alt DOUBLE NOT NULL,
  picture LONGBLOB,
  PRIMARY KEY (facebook_id)
);

source addPOIs.sql;
source addPOItesting.sql

