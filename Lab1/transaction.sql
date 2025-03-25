SET search_path TO :schema_name;
DO $$
BEGIN
    INSERT INTO sun_systems(name, location, description)
    VALUES
    ('Sol', ROW(0.4, 0.3, 0.5)::LOCATION, 'Our Human System'),
    ('Alpha Centuri', ROW(4.323, 0.9, 324.2)::LOCATION, 'Nearest star system to Sol'),
    ('Sirius', ROW(54.3, 2.9, 0.09)::LOCATION, 'Brightest star in the universe');

    INSERT INTO planets(name, location, purpose, description, system_id) 
    VALUES
    ('Earth', ROW(1.0, 2.3, 3.5)::LOCATION, 'life', 'Our home planet', (SELECT system_id FROM sun_systems WHERE name = 'Sol')),
    ('Marsie', ROW(1.9, 5.323, 333.3)::LOCATION, 'heavy_metal_industry', 'Planet with rare materials, metals, minerals', (SELECT system_id FROM sun_systems WHERE name = 'Alpha Centuri')),
    ('Gracie', ROW(2.34, 9.99, 1000.2)::LOCATION, 'relax', 'Funny world with infinity paths', (SELECT system_id FROM sun_systems WHERE name = 'Sirius')),
    ('Valencia', ROW(2.35, 235235, 23)::LOCATION, 'military', 'The world of warriros', (SELECT system_id FROM sun_systems WHERE name = 'Sol'));

    INSERT INTO planet_climate(number_of_regions, avarage_humidity, avarage_rain, planet_id)
    VALUES
    (4, 100, 20.5, (SELECT planet_id FROM planets WHERE name = 'Earth')),
    (5, 34, 100, (SELECT planet_id FROM planets WHERE name = 'Marsie')),
    (34, 23, 100, (SELECT planet_id FROM planets WHERE name = 'Gracie'));

    INSERT INTO satelites(name, active_date, mission, planet_id)
    VALUES
    ('sputnik', '1999-02-01', 'It is used to measure the change in water level ', (SELECT planet_id FROM planets WHERE name = 'Earth')),
    ('the dasher', '2000-09-01', 'It is used to measure the thickness of the ozone layer', (SELECT planet_id FROM planets WHERE name = 'Earth')),
    ('the watcher', '2006-09-02', 'It is used to measure the concentration of CO2 gas', (SELECT planet_id FROM planets WHERE name = 'Gracie')),
    ('the eagle', '2010-10-02', 'It is used for military mission', (SELECT planet_id FROM planets WHERE name = 'Marsie'));

    INSERT INTO satelite_info(brand, generation, weight, speed_per_hr, satelite_id)
    VALUES
    ('TesX', 'first', 345, 25, (SELECT satelite_id FROM satelites WHERE name = 'the watcher')),
    ('Vodka', 'second', 100, 30, (SELECT satelite_id FROM satelites WHERE name = 'sputnik')),
    ('FactorZ', 'fifth', 90, 42, (SELECT satelite_id FROM satelites WHERE name = 'the eagle')),
    ('InHuman', 'third', 120, 42, (SELECT satelite_id from satelites WHERE name = 'the dasher'));

    INSERT INTO characters(name, age, location, occupation)
    VALUES
    ('Alice', 25, ROW(0.0, 2.0, 3.0)::LOCATION, 'student'),
    ('Dath Vader', 300, ROW(1.0, 2.90, 100)::LOCATION, 'Lord'),
    ('Clark Kent', 20, ROW(1.9, 2.8, 8.3)::LOCATION, 'Journalist');

    INSERT INTO arguments(argument_type, description, author)
    VALUES
    ('scientific', 'It is habitable', 'Van Der Mord'),
    ('political', 'It is an important strategic location in economic development', 'D.Trump'),
    ('ethical', 'All of people here are optimists', 'Vin Dissel');

    INSERT INTO characters_planets(character_id, planet_id, favorite_rating, review) 
    VALUES
    (1, 1, 'high', 'this is a friendly place.'),
    (2, 2, 'low', 'this is a harsh place to live.'),
    (3, 3, 'high', 'it made my day.');

    INSERT INTO planets_arguments(planet_id, argument_id, widespread_level, correctness_level)
    VALUES
    (1, 1, 'high', 'high'),
    (2, 3, 'high', 'medium'),
    (3, 3, 'medium', 'high');

  EXCEPTION 
    WHEN OTHERS THEN
      ROLLBACK;
      RAISE;
END $$;
