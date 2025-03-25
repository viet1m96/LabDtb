SET search_path TO :schema_name;


CREATE TYPE LOCATION AS (
    x FLOAT,
    y FLOAT,
    z FLOAT
);


CREATE TABLE sun_systems (
    system_id SERIAL PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL,
    location LOCATION,
    description TEXT
);

CREATE TYPE PURPOSE AS ENUM (
    'life',
    'heavy_metal_industry',
    'military',
    'relax',
    'others'
);

CREATE TABLE planets (
    planet_id SERIAL PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL,
    location LOCATION,
    purpose PURPOSE,
    description TEXT,
    system_id INTEGER NOT NULL REFERENCES sun_systems(system_id)
);

CREATE TABLE planet_climate (
    climate_id SERIAL PRIMARY KEY,
    planet_id INTEGER UNIQUE NOT NULL,
    number_of_regions INTEGER,
    avarage_humidity FLOAT,
    avarage_rain FLOAT,
    FOREIGN KEY (planet_id) REFERENCES planets (planet_id)
);
ALTER TABLE planet_climate
ADD CONSTRAINT check_regions
CHECK (number_of_regions > 0);

ALTER TABLE planet_climate
ADD CONSTRAINT check_humidity
CHECK (avarage_humidity > 0);

ALTER TABLE planet_climate
ADD CONSTRAINT check_rain
CHECK (avarage_rain > 0);



CREATE TABLE satelites (
    satelite_id SERIAL PRIMARY KEY,
    planet_id INTEGER NOT NULL,
    name VARCHAR(30),
    active_date DATE,
    mission VARCHAR(255),
    FOREIGN KEY (planet_id) REFERENCES planets (planet_id)
);


CREATE TYPE GEN AS ENUM (
    'first',
    'second',
    'third',
    'fourth',
    'fifth'
);

CREATE TABLE satelite_info (
    satelite_info_id SERIAL PRIMARY KEY,
    satelite_id INTEGER UNIQUE NOT NULL,
    brand VARCHAR(20),
    generation GEN,
    weight FLOAT,
    speed_per_hr FLOAT,
    FOREIGN KEY (satelite_id) REFERENCES satelites (satelite_id)
);

ALTER TABLE satelite_info
ADD CONSTRAINT check_speed
CHECK (speed_per_hr < 1000 AND speed_per_hr > 0);

ALTER TABLE satelite_info
ADD CONSTRAINT check_weight
CHECK (weight > 0);

CREATE TABLE characters (
    character_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    age INTEGER,
    location LOCATION,
    occupation VARCHAR(255)
);
ALTER TABLE characters
ADD CONSTRAINT check_age
CHECK (age > 0);

CREATE TYPE ARG_TYPE AS ENUM (
    'scientific', 
    'ethical', 
    'economic', 
    'political', 
    'philosophical', 
    'others'
);

CREATE TABLE arguments (
    argument_id SERIAL PRIMARY KEY,
    argument_type ARG_TYPE NOT NULL,
    description TEXT NOT NULL,
    author VARCHAR(50)
);

CREATE TYPE DEGREE AS ENUM (
    'high', 
    'medium', 
    'low', 
    'none'
);


CREATE TABLE characters_planets (
    travel_id SERIAL PRIMARY KEY,
    character_id INTEGER NOT NULL REFERENCES characters(character_id),
    planet_id INTEGER REFERENCES planets(planet_id),
    favorite_rating DEGREE,
    review text
);

CREATE TABLE planets_arguments (
    planet_arg_id SERIAL PRIMARY KEY,
    planet_id INTEGER NOT NULL REFERENCES planets(planet_id),
    argument_id INTEGER REFERENCES arguments(argument_id),
    widespread_level DEGREE,
    correctness_level DEGREE
);
