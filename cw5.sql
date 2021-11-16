CREATE EXTENSION postgis;

CREATE TABLE obiekty(
	id INT PRIMARY KEY,
	name VARCHAR,
	geom GEOMETRY
	);
	
INSERT INTO obiekty(id,name, geom) VALUES
	(1,'Obiekt1',ST_GeomFromEWKT
	 							('SRID=0;
								 COMPOUNDCURVE(
								 (0 1, 1 1),CIRCULARSTRING(1 1, 2 0, 3 1), 
								 CIRCULARSTRING(3 1, 4 2, 5 1),(5 1, 6 1))'));
	 
INSERT INTO obiekty(id,name, geom) VALUES
	(2,'Obiekt2',ST_GeomFromEWKT
	 							('SRID=0; 
								 CURVEPOLYGON(COMPOUNDCURVE(LINESTRING(10 6, 14 6), 
								 CIRCULARSTRING(14 6, 16 4, 14 2), 
							     CIRCULARSTRING(14 2, 12 0, 10 2), 
								 LINESTRING(10 2, 10 6)), 
								 CIRCULARSTRING(11 2, 13 2, 11 2))'));


INSERT INTO obiekty(id, name, geom) VALUES
	(3,'Obiekt3',ST_GeomFromEWKT
	 					('SRID=0;
						 CURVEPOLYGON(COMPOUNDCURVE((7 15, 10 17),(10 17, 12 13),(12 13, 7 15)))'));
						
INSERT INTO obiekty(id, name, geom) VALUES
	(4,'Obiekt4',ST_GeomFromEWKT
	 					('SRID=0;
						 COMPOUNDCURVE((20 20, 25 25),(25 25, 27 24), 
						 							(27 24, 25 22), (25 22, 26 21), 
						 							(26 21, 22 19), (22 19, 20.5 19.5))'));
				
INSERT INTO obiekty(id, name, geom) VALUES
	(5,'Obiekt5',ST_GeomFromEWKT
	 					('SRID=0;
						 MULTIPOINTM((30 30 59),(38 32 234))'));

INSERT INTO obiekty(id, name, geom) VALUES
	(6, 'Obiekt6', ST_GeomFromEWKT
						('SRID=0;
						 GEOMETRYCOLLECTION(POINT(4 2), LINESTRING(1 1, 3 2))'));
	 
SELECT name, ST_CurveToLine(geom) FROM obiekty

--1. Wyznacz pole powierzchni bufora o wielkości 5 jednostek, który został utworzony wokół najkrótszej linii łączącej 
--obiekt 3 i 4.
SELECT ST_Area(ST_Buffer(ST_ShortestLine(
						(SELECT geom
							FROM obiekty
								WHERE name = 'Obiekt3'),
									(SELECT geom
									 	FROM obiekty
											WHERE name = 'Obiekt4')),5));


--2. Zamień obiekt4 na poligon. Jaki warunek musi być spełniony, aby można było wykonać to zadanie? Zapewnij te 
--warunki.

SELECT ST_MakePolygon(ST_LineMerge(ST_CollectionExtract(ST_Union(geom, 'LINESTRING(20.5 19.5 , 20 20)'), 2)))
	FROM obiekty 
		WHERE name = 'Obiekt4';

--ST_LineString zwroci multistring
--ST_CollectionExtract - zwróci multi-geometry
--DELETE FROM obiekty WHERE name = 'Obiekt4'
--SELECT name, ST_CurveToLine(geom) FROM obiekty WHERE name = 'Obiekt4'

--3. W tabeli obiekty, jako obiekt7 zapisz obiekt złożony z obiektu 3 i obiektu 4.
INSERT INTO obiekty(id, name, geom) VALUES
	(7,'Obiekt7',
	 			(SELECT ST_Union((SELECT geom
										FROM obiekty
											WHERE name = 'Obiekt3'),
												(SELECT geom
									 				FROM obiekty
														WHERE name = 'Obiekt4'))));

--ST_Collect
--SELECT name, ST_CurveToLine(geom) FROM obiekty WHERE name = 'Obiekt7'

--4. Wyznacz pole powierzchni wszystkich buforów o wielkości 5 jednostek, które zostały utworzone wokół obiektów 
--nie zawierających łuków.								
SELECT name, ST_Area(ST_Buffer(geom, 5)) 
	FROM obiekty 
		WHERE ST_HasArc(geom)=false;
						
								
								
								
								