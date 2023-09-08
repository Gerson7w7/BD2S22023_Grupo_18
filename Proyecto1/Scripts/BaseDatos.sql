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

-- Franchise
CREATE TABLE Franchise
(
	franchise INT PRIMARY KEY,
    name VARCHAR(100),
);
GO

CREATE TABLE Franchises
(
    franchises INT PRIMARY KEY,
    Franchise_franchise INT,
    Games_game INT,
    FOREIGN KEY (Franchise_franchise) REFERENCES Franchise(franchise),
    FOREIGN KEY (Games_game) REFERENCES Game(game)
);
GO

-- PlayerPerspective

CREATE TABLE PlayerPerspective
(
	player_perspective INT PRIMARY KEY,
    name VARCHAR(255),
);
GO

CREATE TABLE PlayerPerspectives
(
    player_perspectives INT PRIMARY KEY,
    PlayerPerspective_player_perspective INT,
    Games_game INT,
    FOREIGN KEY (PlayerPerspective_player_perspective) REFERENCES PlayerPerspective(player_perspective),
    FOREIGN KEY (Games_game) REFERENCES Game(game)
);
GO

-- Company
DROP TABLE IF EXISTS Company;
GO;
CREATE TABLE Company
(
	company INT PRIMARY KEY,
    name VARCHAR(255),
	description TEXT,
);
GO

DROP TABLE IF EXISTS InvolvedCompany;
GO;
CREATE TABLE InvolvedCompany
(
    involved_companie INT PRIMARY KEY,
	Company_company INT,
    developer CHAR(1),
	porting CHAR(1),
	publisher CHAR(1),
	supporting CHAR(1),
	FOREIGN KEY (Company_company) REFERENCES Company(company)
);
GO

DROP TABLE IF EXISTS InvolvedCompanies;
GO;
CREATE TABLE InvolvedCompanies
(
    involved_companies INT PRIMARY KEY,
    InvolvedCompany_involved_companie INT,
    Games_game INT,
    FOREIGN KEY (InvolvedCompany_involved_companie) REFERENCES InvolvedCompany(involved_companie),
    FOREIGN KEY (Games_game) REFERENCES Game(game)
);
GO

-- GameEngine
DROP TABLE IF EXISTS GameEngine;
GO;
CREATE TABLE GameEngine
(
	game_engine INT PRIMARY KEY,
    name VARCHAR(150),
);
GO

CREATE TABLE GameEngines
(
    game_engines INT PRIMARY KEY,
    GameEngine_game_engine INT,
    Games_game INT,
    FOREIGN KEY (GameEngine_game_engine) REFERENCES GameEngine(game_engine),
    FOREIGN KEY (Games_game) REFERENCES Game(game)
);
GO

-- GameMode

CREATE TABLE GameMode
(
	game_mode INT PRIMARY KEY,
    name VARCHAR(255),
);
GO

CREATE TABLE GameModes
(
    game_modes INT PRIMARY KEY,
    GameMode_game_mode INT,
    Games_game INT,
    FOREIGN KEY (GameMode_game_mode) REFERENCES GameMode(game_mode),
    FOREIGN KEY (Games_game) REFERENCES Game(game)
);
GO
CREATE TABLE Genre
(
	genre 	INT PRIMARY KEY,
	name	VARCHAR(255)
)
CREATE TABLE Genres
(
	genres 	INT PRIMARY KEY,
	genre	INT,
	game	INT,
	FOREIGN KEY (genre) REFERENCES Genre(genre),
	FOREIGN KEY (game) REFERENCES Game(game)
);
CREATE TABLE Platform
(
	platform	INT PRIMARY KEY,
	name		VARCHAR(255)
)
CREATE TABLE Platforms
(
	platforms	INT PRIMARY KEY,
	platform	INT,
	game		INT,
	FOREIGN KEY (platform) REFERENCES Platform(platform),
	FOREIGN KEY (game) REFERENCES Game(game)
)
CREATE TABLE GameLocalization
(
    game_localization INT PRIMARY KEY,
    name              VARCHAR(255),
    region            INT, 
    FOREIGN KEY (region) REFERENCES Region(region)
)   
CREATE TABLE GameLocalizations
(
    game_localizations INT PRIMARY KEY,
    game_localization  INT,
    game               INT,
    FOREIGN KEY (game_localization) REFERENCES GameLocalization(game_localization)
    FOREIGN KEY (game) REFERENCES Game(game)
)   