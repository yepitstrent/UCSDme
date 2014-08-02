USE ucsdme;
  
-- Categories
INSERT INTO categories (name) VALUES ("Classrooms");
INSERT INTO categories (name) VALUES ("Auditorium");
INSERT INTO categories (name) VALUES ("Parking");
INSERT INTO categories (name) VALUES ("Recreation");
INSERT INTO categories (name) VALUES ("Dorms");
INSERT INTO categories (name) VALUES ("Art");
INSERT INTO categories (name) VALUES ("Library");
INSERT INTO categories (name) VALUES ("Computer Lab");
INSERT INTO categories (name) VALUES ("Food");
INSERT INTO categories (name) VALUES ("Coffee");
INSERT INTO categories (name) VALUES ("Bar");
INSERT INTO categories (name) VALUES ("Research Facility");
  
-- Colleges
INSERT INTO categories (name) VALUES ("Warren");
INSERT INTO categories (name) VALUES ("Muir");
INSERT INTO categories (name) VALUES ("Marshall");
INSERT INTO categories (name) VALUES ("Roosevelt");
INSERT INTO categories (name) VALUES ("Sixth");
INSERT INTO categories (name) VALUES ("Revelle");
  
-- Library
INSERT INTO pois (lat, lon,alt, name) VALUES (32.881137,-117.237564,3,"Giesel Library");
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="Giesel Library"),
  (SELECT cat_id FROM categories WHERE name="Library")
);
  
INSERT INTO pois (lat, lon, alt, name) VALUES (32.877938,-117.237275,3,"Center Hall");
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="Center Hall"),
  (SELECT cat_id FROM categories WHERE name="Classrooms")
);
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="Center Hall"),
  (SELECT cat_id FROM categories WHERE name="Coffee")
);
  
-- Fields
INSERT INTO pois (lat, lon, alt, name) VALUES (32.880093,-117.230559,3,"Warren Field");
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="Warren Field"),
  (SELECT cat_id FROM categories WHERE name="Recreation")
);
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="Warren Field"),
  (SELECT cat_id FROM categories WHERE name="Warren")
);
  
INSERT INTO pois (lat, lon, alt, name) VALUES (32.88229,-117.241784,3,"Marshall College Field");
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="Marshall College Field"),
  (SELECT cat_id FROM categories WHERE name="Recreation")
);
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="Marshall College Field"),
  (SELECT cat_id FROM categories WHERE name="Marshall")
);
  
INSERT INTO pois (lat, lon, alt, name) VALUES (32.887257,-117.239614,3,"North Campus Recreation Area");
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="North Campus Recreation Area"),
  (SELECT cat_id FROM categories WHERE name="Recreation")
);
  
INSERT INTO pois (lat, lon, alt, name) VALUES (32.880726,-117.231707,3,"Canyonview Aquatics and Activities Center");
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="Canyonview Aquatics and Activities Center"),
  (SELECT cat_id FROM categories WHERE name="Recreation")
);
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="Canyonview Aquatics and Activities Center"),
  (SELECT cat_id FROM categories WHERE name="Sixth")
);
  
INSERT INTO pois (lat, lon, alt, name) VALUES (32.881967,-117.234114,3,"Warren Bear");
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="Warren Bear"),
  (SELECT cat_id FROM categories WHERE name="Art")
);
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="Warren Bear"),
  (SELECT cat_id FROM categories WHERE name="Warren")
);
  
  
INSERT INTO pois (lat, lon, alt, name) VALUES (32.882026,-117.233579,3,"CSE Building (EBU3B)");
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="CSE Building (EBU3B)"),
  (SELECT cat_id FROM categories WHERE name="Classrooms")
);
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="CSE Building (EBU3B)"),
  (SELECT cat_id FROM categories WHERE name="Warren")
);
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="CSE Building (EBU3B)"),
  (SELECT cat_id FROM categories WHERE name="Coffee")
);
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="CSE Building (EBU3B)"),
  (SELECT cat_id FROM categories WHERE name="Computer Lab")
);
  
  
INSERT INTO pois (lat, lon, alt, name) VALUES (32.881764,-117.234368,3,"Powell-Focht Bioengineering Hall (EBU3A)");
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="Powell-Focht Bioengineering Hall (EBU3A)"),
  (SELECT cat_id FROM categories WHERE name="Classrooms")
);
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="Powell-Focht Bioengineering Hall (EBU3A)"),
  (SELECT cat_id FROM categories WHERE name="Warren")
);
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="Powell-Focht Bioengineering Hall (EBU3A)"),
  (SELECT cat_id FROM categories WHERE name="Research Facility")
);
  
INSERT INTO pois (lat, lon, alt, name) VALUES (32.882581,-117.234797,3,"Atkinson Hall");
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="Atkinson Hall"),
  (SELECT cat_id FROM categories WHERE name="Classrooms")
);
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="Atkinson Hall"),
  (SELECT cat_id FROM categories WHERE name="Auditorium")
);
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="Atkinson Hall"),
  (SELECT cat_id FROM categories WHERE name="Warren")
);
  
INSERT INTO pois (lat, lon, alt, name) VALUES (32.881678,-117.235236,3,"Jacobs SoE (EBUI)");
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="Jacobs SoE (EBUI)"),
  (SELECT cat_id FROM categories WHERE name="Classrooms")
);
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="Jacobs SoE (EBUI)"),
  (SELECT cat_id FROM categories WHERE name="Computer Lab")
);
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="Jacobs SoE (EBUI)"),
  (SELECT cat_id FROM categories WHERE name="Warren")
);
  
  
  
-- Restaurants/Bars
INSERT INTO pois (lat, lon, alt, name) VALUES (32.876632,-117.239656,3,"Porters Pub");
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="Porters Pub"),
  (SELECT cat_id FROM categories WHERE name="Bar")
);
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="Porters Pub"),
  (SELECT cat_id FROM categories WHERE name="Food")
);
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="Porters Pub"),
  (SELECT cat_id FROM categories WHERE name="Muir")
);
  
  
  
INSERT INTO pois (lat, lon, alt, name) VALUES (32.87965,-117.2364,3,"Price Center");
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="Price Center"),
  (SELECT cat_id FROM categories WHERE name="Food")
);
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="Price Center"),
  (SELECT cat_id FROM categories WHERE name="Coffee")
);
  
INSERT INTO pois (lat, lon, alt, name) VALUES (32.884026,-117.233279,3,"Canyon Vista");
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="Canyon Vista"),
  (SELECT cat_id FROM categories WHERE name="Food")
);
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="Canyon Vista"),
  (SELECT cat_id FROM categories WHERE name="Coffee")
);
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="Canyon Vista"),
  (SELECT cat_id FROM categories WHERE name="Warren")
);
  
  
  
INSERT INTO pois (lat, lon, alt, name) VALUES (32.87856,-117.239678,3,"Sun God");
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="Sun God"),
  (SELECT cat_id FROM categories WHERE name="Art")
);
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="Sun God"),
  (SELECT cat_id FROM categories WHERE name="Muir")
);
  
INSERT INTO pois (lat, lon, alt, name) VALUES (32.878857,-117.241663,3,"Ledden Auditorium");
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="Ledden Auditorium"),
  (SELECT cat_id FROM categories WHERE name="Auditorium")
);
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="Ledden Auditorium"),
  (SELECT cat_id FROM categories WHERE name="Classrooms")
);
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="Ledden Auditorium"),
  (SELECT cat_id FROM categories WHERE name="Research Facility")
);
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="Ledden Auditorium"),
  (SELECT cat_id FROM categories WHERE name="Muir")
);
  
INSERT INTO pois (lat, lon, alt, name) VALUES (32.885272,-117.239227,3,"RIMAC");
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="RIMAC"),
  (SELECT cat_id FROM categories WHERE name="Recreation")
);
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="RIMAC"),
  (SELECT cat_id FROM categories WHERE name="Roosevelt")
);
  
-- Residences
INSERT INTO pois (lat, lon, alt, name) VALUES (32.884993,-117.242795,3,"Earth Hall (South)");
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="Earth Hall (South)"),
  (SELECT cat_id FROM categories WHERE name="Dorms")
);
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="Earth Hall (South)"),
  (SELECT cat_id FROM categories WHERE name="Roosevelt")
);
  
INSERT INTO pois (lat, lon, alt, name) VALUES (32.878765,-117.230972,3,"Matthews Apartments");
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="Matthews Apartments"),
  (SELECT cat_id FROM categories WHERE name="Dorms")
);
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="Matthews Apartments"),
  (SELECT cat_id FROM categories WHERE name="Sixth")
);
  
-- Parking
INSERT INTO pois (lat, lon, alt, name) VALUES (32.883944,-117.239378,3,"Hopkins Parking Structure");
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="Hopkins Parking Structure"),
  (SELECT cat_id FROM categories WHERE name="Parking")
);
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="Hopkins Parking Structure"),
  (SELECT cat_id FROM categories WHERE name="Roosevelt")
);
  
INSERT INTO pois (lat, lon, alt, name) VALUES (32.884312,-117.242983,3,"Pangea Parking Structure");
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="Pangea Parking Structure"),
  (SELECT cat_id FROM categories WHERE name="Parking")
);
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="Pangea Parking Structure"),
  (SELECT cat_id FROM categories WHERE name="Roosevelt")
);
  
INSERT INTO pois (lat, lon, alt, name) VALUES (32.87778,-117.23374,3,"Gilman Parking Structure");
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="Gilman Parking Structure"),
  (SELECT cat_id FROM categories WHERE name="Parking")
);
