USE ucsdme;

-- Categories
INSERT INTO categories (name) VALUES ("Testing");

-- Testing
INSERT INTO pois (lat, lon, alt, name) VALUES (32.801443,-117.230169,5,"Sean's House");
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="Sean's House"),
  (SELECT cat_id FROM categories WHERE name="Testing")
);

INSERT INTO pois (lat, lon, alt, name) VALUES (32.801252,-117.233015,5,"Ivory Thai");
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="Ivory Thai"),
  (SELECT cat_id FROM categories WHERE name="Testing")
);

INSERT INTO pois (lat, lon, alt, name) VALUES (32.801967,-117.238963,116,"The Good Vons");
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="The Good Vons"),
  (SELECT cat_id FROM categories WHERE name="Testing")
);
  
INSERT INTO pois (lat, lon, alt, name) VALUES (32.799737,-117.223830,116,"Mission Bay High School");
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="Mission Bay High School"),
  (SELECT cat_id FROM categories WHERE name="Testing")
);
  
INSERT INTO pois (lat, lon, alt, name) VALUES (32.801054,-117.220451,116,"Mission Bay Athletic Area");
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="Mission Bay Athletic Area"),
  (SELECT cat_id FROM categories WHERE name="Testing")
);
  
INSERT INTO pois (lat, lon, alt, name) VALUES (32.808268,-117.216239,116,"Bicycle Warehouse");
INSERT INTO poiToCategory (poi_id,cat_id) VALUES
(
  (SELECT poi_id FROM pois WHERE name="Bicycle Warehouse"),
  (SELECT cat_id FROM categories WHERE name="Testing")
);
