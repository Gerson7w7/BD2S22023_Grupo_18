-- TPO 100 JUEGOS EVALUADOS POR RATING SEGÚN SITIO WEB
CREATE VIEW dbo.Consulta1
AS
SELECT g.name, g.rating, STRING_AGG(plat.name, ', ') AS plataformas, gen.generos
	FROM Game g
	LEFT JOIN (
	    SELECT gens.game, STRING_AGG(gen.name, ', ') AS generos
		    FROM Genres gens
		    INNER JOIN Genre gen ON gen.genre = gens.genre
		    GROUP BY gens.game
	) gen ON gen.game = g.game
	LEFT JOIN Platforms plats ON plats.game = g.game
	LEFT JOIN Platform plat ON plat.platform = plats.platform
	GROUP BY g.name, g.rating, gen.generos
	ORDER BY rating DESC, g.name
	OFFSET 0 ROWS FETCH FIRST 100 ROWS ONLY;

-- TPO 100 JUEGOS QUE SOPORTAN MÁS IDIOMAS
CREATE VIEW dbo.Consulta4 
AS
SELECT t2.name, t2.rating, t2.cantidad_idiomas, t1.idiomas
	FROM (
			SELECT Games_game AS game, STRING_AGG(name, ', ') AS idiomas
			FROM (
			    SELECT DISTINCT ls.Games_game, lan.name
			    FROM LanguageSupports ls
			    LEFT JOIN Languages lan ON lan.[language] = ls.Languages_language
			) AS s1
			GROUP BY Games_game
		) AS t1
	LEFT JOIN
		(
			SELECT g.name, g.rating, Games_game, COUNT(*) AS cantidad_idiomas
			FROM LanguageSupports ls
			LEFT JOIN Game g ON g.game = Games_game
			GROUP BY Games_game, g.name, g.rating
		) AS t2 ON t2.Games_game = t1.game
	ORDER BY cantidad_idiomas DESC, rating DESC, name
	OFFSET 0 ROWS FETCH FIRST 100 ROWS ONLY;

-- Modificar vista
ALTER VIEW dbo.Consulta1 -- Nombre de la vista
AS
-- Aquí se pone el nuevo SELECT;

-- Llamar vistas
SELECT * FROM Consulta1;
SELECT * FROM Consulta4;