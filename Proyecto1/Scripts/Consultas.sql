SELECT DISTINCT TOP 100
    G.name AS NombreDelJuego,
    STUFF((
        SELECT ', ' + Genre.name
        FROM Genres GG
        INNER JOIN Genre ON GG.genre = Genre.genre
        WHERE GG.game = G.game
        FOR XML PATH('')), 1, 2, '') AS Generos,
    G.rating AS Rating
FROM Game G
ORDER BY G.rating DESC;