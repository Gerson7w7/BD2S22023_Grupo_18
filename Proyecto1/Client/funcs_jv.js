const axios = require('axios');
const sleep = (milliseconds) => new Promise(resolve => setTimeout(resolve, milliseconds));
const sql = require('mssql');

let igdbHeaders = null;
const config = {
    user: 'sqlserver',
    password: 'bd2g18',
    server: '35.238.234.9', // Puede ser 'localhost', IP de la BD
    database: 'Videojuegos',
    options: {
      encrypt: true,
      trustServerCertificate: true // Cambiado a false para entorno de producción
    }
};
  
async function conectar(query){
    try{
        const pool = await sql.connect(config);
        const request = new sql.Request(pool);
        const query = `INSERT INTO GameMode VALUES (1, 'hola')`;
        await request.query(query);
    } catch (error) {
        console.error('Error principal:', error);
    } finally {
        sql.close();
    }
}

async function autenticar() {
    const twitchClientId = '62qm5p8ddoco5cb5jeoz3urq7mhj3r';
    const twitchClientSecret = '8ob453vrwdv9r753ap0vtw210yr0hn';
    const twitchAuthUrl = 'https://id.twitch.tv/oauth2/token';

    const authParams = {
        client_id: twitchClientId,
        client_secret: twitchClientSecret,
        grant_type: 'client_credentials'
    };

    try {
        const response = await axios.post(twitchAuthUrl, authParams);
        twitchAuthData = response.data;
        igdbAccesssToken = twitchAuthData.access_token;
        igdbHeaders = {
            'Client-ID': '62qm5p8ddoco5cb5jeoz3urq7mhj3r',
            'Authorization': `Bearer ${igdbAccesssToken}`
        };
    } catch (error) {
        console.error("Error:", error);
        process.exit(1);
    }
}

// GameMode
// - game_mode
// - name

async function getGameModes() {
    const igdbUrl = 'https://api.igdb.com/v4/game_modes';
    const igdbSearchParams = "fields: *; limit: 500; offset 0; sort id asc; where id >=0;";
    await autenticar();
    
    try {
        const pool = await sql.connect(config);
        const igdbResponse = await axios.post(igdbUrl, igdbSearchParams, { headers: igdbHeaders });
        if (igdbResponse.status === 200) {
            const games = igdbResponse.data;
            for (const game of games) {
                const request = new sql.Request(pool);
                const query = `INSERT INTO GameMode VALUES (${game.id}, '${game.name}')`;
                await request.query(query);
            }
        } else {
            console.log(`Error al realizar la solicitud a IGDB: ${igdbResponse.status}`);
        }
    } catch (error) {
        console.error("Error:", error);
    } finally {
        sql.close();
    }
    await sleep(4000);
}

// GameEngine
// - game_engine
// - description
// - name

async function getGameEngines() {
    const igdbUrl = 'https://api.igdb.com/v4/game_engines';
    let ini = 0;

    while (true) {
        const igdbSearchParams = `fields: *; limit: 500; offset 0; sort id asc; where id >${ini};`;

        try {
            const pool = await sql.connect(config);
            await autenticar();
            const igdbResponse = await axios.post(igdbUrl, igdbSearchParams, { headers: igdbHeaders });

            if (igdbResponse.status === 200) {
                const games = igdbResponse.data;

                if (games.length === 0) {
                    break; // Salir del bucle si no hay más resultados
                }

                for (const game of games) {
                    const request = new sql.Request(pool);
                    request.input('id', sql.Int, game.id);
                    request.input('name', sql.NVarChar, game.name);

                    const query = `INSERT INTO GameEngine VALUES (@id, @name)`;
                    await request.query(query);
                }

                ini = games[games.length - 1].id;
                await sleep(4000);
            } else {
                console.log(`Error al realizar la solicitud a IGDB: ${igdbResponse.status}`);
                break; // Salir del bucle en caso de error
            }
        } catch (error) {
            console.error("Error:", error);
            break; // Salir del bucle en caso de error
        } finally {
            sql.close();
        }
    }
}


// Franchise
// - franchise
// - name

async function getFranchises() {
    const igdbUrl = 'https://api.igdb.com/v4/franchises';
    let ini = 0;

    while (true) {
        const igdbSearchParams = `fields: *; limit: 500; offset 0; sort id asc; where id >${ini};`;

        try {
            const pool = await sql.connect(config);
            await autenticar();
            const igdbResponse = await axios.post(igdbUrl, igdbSearchParams, { headers: igdbHeaders });

            if (igdbResponse.status === 200) {
                const games = igdbResponse.data;

                if (games.length === 0) {
                    break; // Salir del bucle si no hay más resultados
                }

                for (const game of games) {
                    const request = new sql.Request(pool);
                    request.input('id', sql.Int, game.id);
                    request.input('name', sql.NVarChar, game.name);

                    const query = `INSERT INTO Franchise VALUES (@id, @name)`;
                    await request.query(query);
                }

                ini = games[games.length - 1].id;
                await sleep(4000);
            } else {
                console.log(`Error al realizar la solicitud a IGDB: ${igdbResponse.status}`);
                break; // Salir del bucle en caso de error
            }
        } catch (error) {
            console.error("Error:", error);
            break; // Salir del bucle en caso de error
        } finally {
            sql.close();
        }
    }
}

// Company
// - company
// - name
// - description
async function getCompanies() {
    const igdbUrl = 'https://api.igdb.com/v4/companies';
    let ini = 0;

    while (true) {
        const igdbSearchParams = `fields: *; limit: 500; offset 0; sort id asc; where id >${ini};`;

        try {
            const pool = await sql.connect(config);
            await autenticar();
            const igdbResponse = await axios.post(igdbUrl, igdbSearchParams, { headers: igdbHeaders });

            if (igdbResponse.status === 200) {
                const games = igdbResponse.data;

                if (games.length === 0) {
                    break; // Salir del bucle si no hay más resultados
                }

                for (const game of games) {
                    console.log(game.id + " - " + game.name + " - " + game.description);
                    const request = new sql.Request(pool);

                    request.input('id', sql.Int, game.id);
                    request.input('name', sql.VarChar(255), game.name);
                    request.input('description', sql.Text, game.description || "No hay descripción");

                    const query = `
                        INSERT INTO Company (company, name, description)
                        VALUES (@id, @name, @description)
                    `;
                    await request.query(query);
                }

                ini = games[games.length - 1].id;
                await sleep(4000);
            } else {
                console.log(`Error al realizar la solicitud a IGDB: ${igdbResponse.status}`);
                break; // Salir del bucle en caso de error
            }
        } catch (error) {
            console.error("Error:", error);
            break; // Salir del bucle en caso de error
        } finally {
            sql.close();
        }
    }
}

// InvolveCompany
// - involved_companie
// - company_CREARTABLA
// - developer
// - porting
// - publisher
// - supporting

async function getInvolvedCompanies() {
    const igdbUrl = 'https://api.igdb.com/v4/involved_companies';
    let ini = 230394;

    while (true) {
        const igdbSearchParams = `fields: *; limit: 500; offset 0; sort id asc; where id >${ini};`;

        try {
            const pool = await sql.connect(config);
            await autenticar();
            const igdbResponse = await axios.post(igdbUrl, igdbSearchParams, { headers: igdbHeaders });

            if (igdbResponse.status === 200) {
                const games = igdbResponse.data;

                if (games.length === 0) {
                    break; // Salir del bucle si no hay más resultados
                }

                for (const game of games) {
                    if(game.id == 230398 || game.id == 230400 || game.id == 230401 || game.id == 230403 || game.id == 230427 || game.id == 230428 || game.id == 230434 || game.id == 230435){
                        const request = new sql.Request(pool);
                        console.log(game.id)
                        request.input('id', sql.Int, game.id);
                        request.input('company', sql.Int, game.company);
                        request.input('developer', sql.Char, game.developer ? 'T' : 'F');
                        request.input('porting', sql.Char, game.porting ? 'T' : 'F');
                        request.input('publisher', sql.Char, game.publisher ? 'T' : 'F');
                        request.input('supporting', sql.Char, game.supporting ? 'T' : 'F');

                        const query = `
                            INSERT INTO InvolvedCompany (involved_companie, Company_company, developer, porting, publisher, supporting)
                            VALUES (@id, @company, @developer, @porting, @publisher, @supporting)
                        `;
                        await request.query(query);                     
                    }
                    /**/

                }

                ini = games[games.length - 1].id;
                await sleep(4000);
            } else {
                console.log(`Error al realizar la solicitud a IGDB: ${igdbResponse.status}`);
                break; // Salir del bucle en caso de error
            }
        } catch (error) {
            console.error("Error:", error);
            break; // Salir del bucle en caso de error
        } finally {
            sql.close();
        }
    }
}

// PlayerPerspective
// - player_perspective
// - name

async function getPlayerPerspectives() {
    const igdbUrl = 'https://api.igdb.com/v4/player_perspectives';
    let ini = 0;

    while (true) {
        const igdbSearchParams = `fields: *; limit: 500; offset 0; sort id asc; where id >${ini};`;

        try {
            const pool = await sql.connect(config);
            await autenticar();
            const igdbResponse = await axios.post(igdbUrl, igdbSearchParams, { headers: igdbHeaders });

            if (igdbResponse.status === 200) {
                const games = igdbResponse.data;

                if (games.length === 0) {
                    break; // Salir del bucle si no hay más resultados
                }

                for (const game of games) {
                    const request = new sql.Request(pool);
                    request.input('id', sql.Int, game.id);
                    request.input('name', sql.VarChar(255), game.name);

                    const query = `
                        INSERT INTO PlayerPerspective (player_perspective, name)
                        VALUES (@id, @name)
                    `;
                    await request.query(query);
                }

                ini = games[games.length - 1].id;
                await sleep(4000);
            } else {
                console.log(`Error al realizar la solicitud a IGDB: ${igdbResponse.status}`);
                break; // Salir del bucle en caso de error
            }
        } catch (error) {
            console.error("Error:", error);
            break; // Salir del bucle en caso de error
        } finally {
            sql.close();
        }
    }
}


async function main() {
    //await getGameModes()
    //await getGameEngines()
    //await getFranchises()
    //await getCompanies()
    await getInvolvedCompanies()
    //await getPlayerPerspectives()
}

main()