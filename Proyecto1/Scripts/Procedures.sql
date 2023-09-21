-- 1. Mostrar el nombre de las plataformas y el nombre de los juegos que se han lanzado en dichas plataformas.
CREATE PROCEDURE PlataformasJuego
    @NombreJuego NVARCHAR(255)
AS
BEGIN
    SELECT p.name AS Plataforma, g.name AS Juego
    FROM Game g
    INNER JOIN Platforms ps ON g.game = ps.game
    INNER JOIN Platform p ON ps.platform = p.platform
    WHERE g.name = @NombreJuego
    GROUP BY p.name, g.name;
END;

EXEC BuscarJuegoPorNombre 'Counter-Strike: Global Offensive';


-- 2. Mostrar información en detalle de un juego en concreto.
CREATE PROCEDURE InfoJuego
    @NombreJuego NVARCHAR(255)
AS
BEGIN
    SELECT 
        g.game,
        g.name AS Juego,
        g.aggregated_rating AS Criticos_Externos,
        g.aggregated_rating_count AS Numero_Criticas,
        g.first_release_date AS Lanzamiento,
        g.rating AS Rating,
        g.rating_count AS Numero_Rating,
        g.storyline AS Historia,
        g.summary AS Resumen, 
        g.total_rating AS Rating_Total,
        g.total_rating_count AS Numero_RT,
        g.version_title,
        g.created_at,
        STRING_AGG(c.name, ', ') AS Companies,
        STRING_AGG(CONVERT(nvarchar(max), c.description), '| ') AS Descr_Companies,
        cll.name AS Coleccion,
        (
            SELECT STRING_AGG(ReleaseInfo, ', ')
            FROM (
                SELECT DISTINCT CONCAT(re.name, ' (', rd.human, ')') AS ReleaseInfo
                FROM ReleaseDate rd
                INNER JOIN RegionEnum re ON rd.region_enum = re.region_enum 
                WHERE rd.game = g.game
            ) ReleaseInfo
        ) AS Release_Date,
        (
            SELECT STRING_AGG(p.name, ', ')
            FROM Platforms ps
            INNER JOIN Platform p ON ps.platform = p.platform
            WHERE ps.game = g.game
        ) AS Plataformas,
        (
            SELECT STRING_AGG(pp.name, ', ')
            FROM (
                SELECT DISTINCT pp.name
                FROM PlayerPerspectives pps 
                INNER JOIN PlayerPerspective pp ON pps.player_perspective = pp.player_perspective 
                WHERE pps.game = g.game
            ) pp
        ) AS PlayerPerspective,
        (
            SELECT STRING_AGG(t.name, ', ')
            FROM (
                SELECT DISTINCT t.name
                FROM Themes ts 
                INNER JOIN Theme t ON ts.theme = t.theme  
                WHERE ts.game = g.game
            ) t
        ) AS Themes,
        (
            SELECT STRING_AGG(Game_Localization, ', ')
            FROM (
                SELECT DISTINCT CONCAT(gl.name, ' (', r.name, ')') AS Game_Localization
                FROM GameLocalization gl 
                INNER JOIN Region r ON gl.region = r.region  
                WHERE gl.game = g.game
            ) Game_Localization
        ) AS Game_Localization,
        (
            SELECT STRING_AGG(Language_Support, ', ')
            FROM (
                SELECT DISTINCT CONCAT(l.name, ' (', (
                    SELECT STRING_AGG(lst.name, ', ')
                    FROM LanguageSupportType lst
                    WHERE lst.language_support_type = ls.LanguageSupportType_languageST 
                ), ')') AS Language_Support
                FROM LanguageSupports ls 
                INNER JOIN Languages l ON ls.Languages_language = l.[language] 
                WHERE ls.Games_game = g.game
            ) Language_Support
        ) AS Language_Support,
        (
            SELECT STRING_AGG(Alternative_Name, ', ')
            FROM (
                SELECT DISTINCT an.name AS Alternative_Name
                FROM AlternativeName an    
                WHERE an.game = g.game
            ) Alternative_Name
        ) AS Alternative_Name,
        (
            SELECT STRING_AGG(Game_Modes, ', ')
            FROM (
                SELECT DISTINCT gm.name AS Game_Modes
                FROM GameModes gms
                INNER JOIN GameMode gm ON gms.game_mode = gm.game_mode 
                WHERE gms.game = g.game
            ) Game_Modes
        ) AS Game_Modes,
        (
            SELECT STRING_AGG(Game_Engines, ', ')
            FROM (
                SELECT DISTINCT ge.name AS Game_Engines
                FROM GameEngines ges 
                INNER JOIN GameEngine ge ON ges.game_engine = ge.game_engine  
                WHERE ges.game = g.game
            ) Game_Engines
        ) AS Game_Engines,
        (
            SELECT STRING_AGG(Franchises, ', ')
            FROM (
                SELECT DISTINCT f.name AS Franchises
                FROM Franchises fs
                INNER JOIN Franchise f ON fs.franchise = f.franchise  
                WHERE fs.game = g.game
            ) Franchises
        ) AS Franchises,
        (
            SELECT STRING_AGG(Genres, ', ')
            FROM (
                SELECT DISTINCT gr.name AS Genres
                FROM Genres grs
                INNER JOIN Genre gr ON grs.genre = gr.genre  
                WHERE grs.game = g.game
            ) Genres
        ) AS Genres 
    FROM Game g 
    INNER JOIN InvolvedCompanies ics ON g.game = ics.game 
    INNER JOIN InvolvedCompany ic ON ics.involved_company = ic.involved_company 
    INNER JOIN Company c ON ic.company = c.company 
    INNER JOIN Collection cll ON g.collection = cll.collection
    WHERE g.name = @NombreJuego
    GROUP BY 
        g.game,
        g.name,
        g.aggregated_rating,
        g.aggregated_rating_count,
        g.first_release_date,
        g.rating,
        g.rating_count,
        g.storyline,
        g.summary,
        g.total_rating,
        g.total_rating_count,
        g.version_title,
        g.created_at,
        cll.name;
END;

EXEC InfoJuego 'Counter-Strike: Global Offensive';