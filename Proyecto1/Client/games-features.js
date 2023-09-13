const fetch = require('node-fetch');
const sql = require('mssql');

const url = "https://api.igdb.com/v4";
let cont = 21556;

const config = {
  user: 'sqlserver',
  password: 'bd2g18',
  server: '35.238.234.9',
  database: 'Videojuegos',
  options: {
    encrypt: true,
    trustServerCertificate: true // Cambiado a false para entorno de producción
  }
};

async function obtenerData(path, fields) {
  try {
    const response = await fetch(
      `${url}/${path}`,
      {
        method: 'POST',
        headers: {
          'Accept': 'application/json',
          'Client-ID': 'h6kl5ez09i12h0fhutgbolmyo66f8s',
          'Authorization': 'Bearer dvwuzxqjw1vttfl6km1hcn0krjf6a1',
        },
        body: `fields ${fields}; limit 500; offset 0; sort id asc; where id >= ${cont};`,
        charset: 'UTF-8'
      }
    );

    const data = await response.json();
    return data;
  } catch (error) {
    throw new Error('Error al obtener datos:', error);
  }
}

async function insertReleaseDates(data, pool) {
    try {
        for (const item of data) {
            const release_date = item.id;
            const date = item.date;
            const region_enum = item.region;
            const game = item.game
            const human = item.human
            const request = new sql.Request(pool);
            request.input('release_date', sql.Int, release_date);

            let query = ''
            request.input('region_enum', sql.Int, region_enum);
            request.input('game', sql.Int, game);
            request.input('human', sql.NVarChar, human);

            if (date) {
                const new_date = new Date(date * 1000);
                const string_date = `${new_date.getUTCFullYear()}-${new_date.getUTCMonth()+1}-${new_date.getUTCDate()}`
                request.input('date', sql.Date, string_date);
                query = `INSERT INTO ReleaseDate (release_date, date, region_enum, game, human) VALUES (@release_date, @date, @region_enum, @game, @human)`;
            } else {
                query = `INSERT INTO ReleaseDate (release_date, region_enum, game, human) VALUES (@release_date, @region_enum, @game, @human)`;
            }
            
            await request.query(query);
            cont = release_date;
        }
    } catch (error) {
        console.error('Error al insertar datos:', error);
    }
}

async function insertTheme(data, pool) {
    try {
        for (const item of data) {
            const theme = item.id;
            const name = item.name
            const request = new sql.Request(pool);
            request.input('theme', sql.Int, theme);
            request.input('name', sql.VarChar, name);
    
            const query = `INSERT INTO Theme (theme, name) VALUES (@theme, @name)`;
            await request.query(query);
    
            cont = theme;
        }
    } catch (error) {
        console.error('Error al insertar datos:', error);
    }
}

async function insertThemes(data, pool) {
    try {
        for (const item of data) {
            const game = item.id
            const themes = item.themes;

            if (themes) {
                const request = new sql.Request(pool);
                request.input('game', sql.Int, game);
                let query = 'INSERT INTO Themes (theme, game) VALUES'

                for (let i = 0; i < themes.length; i++) {
                    request.input(`theme${i}`, sql.Int, themes[i]);
                    query += (i > 0)? `, (@theme${i}, @game)`:`(@theme${i}, @game)`;
                }
                await request.query(query);
            }
            cont = game;
        }
    } catch (error) {
        console.error('Error al insertar datos: ', error);
    }
}

async function insertRegion(data, pool) {
    try {
        for (const item of data) {
        const region = item.id;
        const name = item.name;
        const request = new sql.Request(pool);
        request.input('region', sql.Int, region);
        request.input('name', sql.NVarChar, name);

        const query = `INSERT INTO Region (region, name) VALUES (@region, @name)`;
        await request.query(query);

        cont = region;
        }
    } catch (error) {
        console.error('Error al insertar datos:', error);
    }
}

async function insertGamesLocalizations(data, pool) {
    try {
        for (const item of data) {
            const game_localization = item.id;
            const name = item.name;
            const region = item.region;
            const game = item.game;

            const request = new sql.Request(pool);
            request.input('game_localization', sql.Int, game_localization);
            request.input('name', sql.NVarChar, name);
            request.input('region', sql.Int, region);
            request.input('game', sql.Int, game);

            const query = `INSERT INTO GameLocalization (game_localization, name, region, game) VALUES (@game_localization, @name, @region, @game)`;
            await request.query(query);
    
            cont = game_localization;
        }
    } catch (error) {
        console.error('Error al insertar datos: ', error);
    }
}

async function insertAlternativeNames(data, pool) {
    try {
        for (const item of data) {
            const alternative_name = item.id;
            const name = item.name;
            const game = item.game
            const request = new sql.Request(pool);
            request.input('alternative_name', sql.Int, alternative_name);
            request.input('name', sql.NVarChar, name);
            request.input('game', sql.Int, game);
    
            const query = `INSERT INTO AlternativeName (alternative_name, name, game) VALUES (@alternative_name, @name, @game)`;
            await request.query(query);
    
            cont = alternative_name;
        }
    } catch (error) {
        console.error('Error al insertar datos:', error);
    }
}

async function main() {
    try {
        const pool = await sql.connect(config);
        while (true) {
            //-------------- Release_Dates ---------------
            //const data = await obtenerData('release_dates', 'game, date, region, human');

            //-------------- Theme ---------------
            //const data = await obtenerData('themes', 'name');

            //-------------- Themes ---------------
            const data = await obtenerData('games', 'themes');

            //-------------- Game_Localizations ---------------
            //const data = await obtenerData('game_localizations', 'name, region, game');

            //-------------- Alternative_Names ---------------
            //const data = await obtenerData('alternative_names', 'name, game');

            if (data.length === 0) break; // Si la lista viene vacía se termina el while

            //await insertReleaseDates(data, pool);
            //await insertTheme(data, pool);
            await insertThemes(data, pool);
            //await insertRegion(data, pool);
            //await insertGamesLocalizations(data, pool);
            //await insertAlternativeNames(data, pool);

            cont += 1;

            //Retraso para no sobrecargar la API
            await new Promise(resolve => setTimeout(resolve, 300));
            console.log("cont: ", cont)
        }
        console.log("Se han insertado todos los datos correctamente.")
    } catch (error) {
        console.error('Error principal:', error);
    } finally {
        sql.close();
    }
}

main();
