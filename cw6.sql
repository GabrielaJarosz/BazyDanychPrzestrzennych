CREATE DATABASE cw6;
EXTENSION postgis;
EXTENSION postgis_raster;

CREATE SCHEMA schema_Jarosz;
CREATE SCHEMA rasters;
CREATE SCHEMA vectors;

CREATE TABLE vectors.railroad();
CREATE TABLE vectors.places();
CREATE TABLE vectors.porto_parishes();

