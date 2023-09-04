USE Videojuegos
GO
CREATE TABLE Collection 
(
	collection INT PRIMARY KEY,
	name VARCHAR(255)
)
GO
CREATE TABLE Game
(
	game					INT PRIMARY KEY,
	aggregated_rating		DECIMAL(3,2),
	aggregated_rating_count INT,
	first_release_date		DATE,
	name					VARCHAR(255),
	rating					DECIMAL(3,2),
	rating_count			INT,
	storyline				VARCHAR(255),
	summary					VARCHAR(255),
	total_rating			DECIMAL(3,2),
	total_rating_count		INT,
	version_title 			VARCHAR(255),
	created_at				DATE,
	collection 				INT,
	FOREIGN KEY (collection) REFERENCES Collection(collection)
)
GO