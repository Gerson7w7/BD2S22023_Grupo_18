const fetch = require("node-fetch");
const sql = require("mssql");

const url = "https://api.igdb.com/v4";
let cont = 196603;
const config = {
  user: "sqlserver",
  password: "bd2g18",
  server: "35.238.234.9", // Puede ser 'localhost', IP de la BD
  database: "Videojuegos",
  options: {
    encrypt: true,
    trustServerCertificate: true, // Cambiado a false para entorno de producción
  },
};

async function obtenerData() {
  try {
    const response = await fetch(`${url}/games`, {
      method: "POST",
      headers: {
        Accept: "application/json",
        "Client-ID": "0ufnhiamg15efiwfbt755uwdpyz5ke",
        Authorization: "Bearer j2go37lrrm65f0ufaffyaj5vt946vc",
      },
      body: `fields *; limit 500; offset 0; sort id asc; where id >= ${cont};`,
    });

    const data = await response.json();
    return data;
  } catch (error) {
    throw new Error("Error al obtener datos:", error);
  }
}

async function insertMuchosAMuchos(data, pool) {
  // 0
  try {
    for (const item of data) {
      let i = 0;
      const game = item.id;
      const involved_companies = item.involved_companies
        ? item.involved_companies
        : null;
      const platforms = item.platforms ? item.platforms : null;
      const player_perspectives = item.player_perspectives
        ? item.player_perspectives
        : null;
      const game_modes = item.game_modes ? item.game_modes : null;
      const game_engines = item.game_engines ? item.game_engines : null;
      const franchises = item.franchises ? item.franchises : null;

      const request = new sql.Request(pool);
      request.input("game", sql.Int, game);
      // // Verificar si ya existe en la base de datos
      // let checkQuery = `SELECT COUNT(*) AS count FROM Game WHERE game = @game`;
      // let checkResult = await request.query(checkQuery);

      // if (checkResult.recordset[0].count !== 0) {
        if (involved_companies != null) {
          for (const involved_company of involved_companies) {
            request.input(`involved_company${i}`, sql.Int, involved_company);

            // Verificar si ya existe en la base de datos
            checkQuery = `SELECT COUNT(*) AS count FROM InvolvedCompanies WHERE game = @game AND involved_company = @involved_company${i}`;
            checkResult = await request.query(checkQuery);

            if (checkResult.recordset[0].count === 0) {
              // Verificar si ya existe en la base de datos
              checkQuery = `SELECT COUNT(*) AS count FROM InvolvedCompany WHERE involved_company = @involved_company${i}`;
              checkResult = await request.query(checkQuery);
              if (checkResult.recordset[0].count !== 0) {
                const query = `INSERT INTO InvolvedCompanies (involved_company, game) VALUES (@involved_company${i}, @game)`;
                await request.query(query);

                console.log(
                  `Insertado el involved companies: Juego ${game}, Involved_company ${involved_company}`
                );
              }
              console.log(
                `involved company no encontrado: Juego ${game}, Involved_company ${involved_company}`
              );
            } else {
              console.log(
                `Involved companies duplicado encontrado: Juego ${game}, Involved_company ${involved_company}`
              );
            }
            i++;
          }
        }

        if (platforms != null) {
          i = 0;
          for (const platform of platforms) {
            request.input(`platform${i}`, sql.Int, platform);

            // Verificar si ya existe en la base de datos
            let checkQuery = `SELECT COUNT(*) AS count FROM Platforms WHERE game = @game AND platform = @platform${i}`;
            let checkResult = await request.query(checkQuery);

            if (checkResult.recordset[0].count === 0) {
              // Verificar si ya existe en la base de datos
              checkQuery = `SELECT COUNT(*) AS count FROM Platform WHERE platform = @platform${i}`;
              checkResult = await request.query(checkQuery);
              if (checkResult.recordset[0].count !== 0) {
                const query = `INSERT INTO Platforms (platform, game) VALUES (@platform${i}, @game)`;
                await request.query(query);

                console.log(
                  `Insertado el platform: Juego ${game}, platform ${platform}`
                );
              }
              console.log(
                `platform no encontrado: Juego ${game}, platform ${platform}`
              );
            } else {
              console.log(
                `platform duplicado encontrado: Juego ${game}, platform ${platform}`
              );
            }
            i++;
          }
        }

        if (player_perspectives != null) {
          i = 0;
          for (const player_perspective of player_perspectives) {
            request.input(
              `player_perspective${i}`,
              sql.Int,
              player_perspective
            );

            // Verificar si ya existe en la base de datos
            let checkQuery = `SELECT COUNT(*) AS count FROM PlayerPerspectives WHERE game = @game AND player_perspective = @player_perspective${i}`;
            let checkResult = await request.query(checkQuery);

            if (checkResult.recordset[0].count === 0) {
              const query = `INSERT INTO PlayerPerspectives (player_perspective, game) VALUES (@player_perspective${i}, @game)`;
              await request.query(query);

              console.log(
                `Insertado el player_perspective: Juego ${game}, player_perspective ${player_perspective}`
              );
            } else {
              console.log(
                `player_perspective duplicado encontrado: Juego ${game}, player_perspective ${player_perspective}`
              );
            }
            i++;
          }
        }

        if (game_modes != null) {
          i = 0;
          for (const game_mode of game_modes) {
            request.input(`game_mode${i}`, sql.Int, game_mode);

            // Verificar si ya existe en la base de datos
            let checkQuery = `SELECT COUNT(*) AS count FROM GameModes WHERE game = @game AND game_mode = @game_mode${i}`;
            let checkResult = await request.query(checkQuery);

            if (checkResult.recordset[0].count === 0) {
              const query = `INSERT INTO GameModes (game_mode, game) VALUES (@game_mode${i}, @game)`;
              await request.query(query);

              console.log(
                `Insertado el game_mode: Juego ${game}, game_mode ${game_mode}`
              );
            } else {
              console.log(
                `game_mode duplicado encontrado: Juego ${game}, game_mode ${game_mode}`
              );
            }
            i++;
          }
        }

        if (game_engines != null) {
          i = 0;
          for (const game_engine of game_engines) {
            request.input(`game_engine${i}`, sql.Int, game_engine);

            // Verificar si ya existe en la base de datos
            let checkQuery = `SELECT COUNT(*) AS count FROM GameEngines WHERE game = @game AND game_engine = @game_engine${i}`;
            let checkResult = await request.query(checkQuery);

            if (checkResult.recordset[0].count === 0) {
              const query = `INSERT INTO GameEngines (game_engine, game) VALUES (@game_engine${i}, @game)`;
              await request.query(query);

              console.log(
                `Insertado el game_engine: Juego ${game}, game_engine ${game_engine}`
              );
            } else {
              console.log(
                `game_engine duplicado encontrado: Juego ${game}, game_engine ${game_engine}`
              );
            }
            i++;
          }
        }

        if (franchises != null) {
          i = 0;
          for (const franchise of franchises) {
            request.input(`franchise${i}`, sql.Int, franchise);

            // Verificar si ya existe en la base de datos
            let checkQuery = `SELECT COUNT(*) AS count FROM Franchises WHERE game = @game AND franchise = @franchise${i}`;
            let checkResult = await request.query(checkQuery);

            if (checkResult.recordset[0].count === 0) {
              // Verificar si ya existe en la base de datos
              checkQuery = `SELECT COUNT(*) AS count FROM Franchise WHERE franchise = @franchise${i}`;
              checkResult = await request.query(checkQuery);
              if (checkResult.recordset[0].count !== 0) {
                const query = `INSERT INTO Franchises (franchise, game) VALUES (@franchise${i}, @game)`;
                await request.query(query);

                console.log(
                  `Insertado el franchise: Juego ${game}, franchise ${franchise}`
                );
              }
              console.log(
                `franchise no encontrado: Juego ${game}, franchise ${franchise}`
              );
            } else {
              console.log(
                `franchise duplicado encontrado: Juego ${game}, franchise ${franchise}`
              );
            }
            i++;
          }
        }
      // }
    }
    return 1;
  } catch (error) {
    console.error("Error al insertar datos:", error);
    return 0;
  }
}

async function insertPlatform(data, pool) {
  // 0
  try {
    for (const item of data) {
      const platform = item.id;
      const name = item.name ? item.name : null;

      const request = new sql.Request(pool);
      request.input("platform", sql.Int, platform);

      // Verificar si el juego ya existe en la base de datos
      let checkQuery = `SELECT COUNT(*) AS count FROM Platform WHERE platform = @platform`;
      let checkResult = await request.query(checkQuery);

      if (checkResult.recordset[0].count === 0) {
        request.input("name", sql.NVarChar, name);
        const query = `INSERT INTO Platform (platform, name) VALUES (@platform, @name)`;
        await request.query(query);

        console.log(`Insertado la plataforma: ID ${genre}, Nombre ${name}`);
      } else {
        console.log(
          `Plataforma duplicado encontrado: ID ${genre}, Nombre ${name}`
        );
      }
    }
    return 1;
  } catch (error) {
    console.error("Error al insertar datos:", error);
    return 0;
  }
}

async function insertGenre(data, pool) {
  // 0
  try {
    for (const item of data) {
      const genre = item.id;
      const name = item.name ? item.name : null;

      const request = new sql.Request(pool);
      request.input("genre", sql.Int, genre);

      // Verificar si el juego ya existe en la base de datos
      let checkQuery = `SELECT COUNT(*) AS count FROM Genre WHERE genre = @genre`;
      let checkResult = await request.query(checkQuery);

      if (checkResult.recordset[0].count === 0) {
        request.input("name", sql.NVarChar, name);
        const query = `INSERT INTO Genre (genre, name) VALUES (@genre, @name)`;
        await request.query(query);

        console.log(`Insertado el genero: ID ${genre}, Nombre ${name}`);
      } else {
        console.log(`Genero duplicado encontrado: ID ${genre}, Nombre ${name}`);
      }
    }
    return 1;
  } catch (error) {
    console.error("Error al insertar datos:", error);
    return 0;
  }
}

async function insertGame(data, pool) {
  // 2623
  try {
    for (const item of data) {
      const game = item.id;
      const aggregated_rating = item.aggregated_rating
        ? parseFloat(item.aggregated_rating).toFixed(2)
        : null;
      const aggregated_rating_count = item.aggregated_rating_count
        ? item.aggregated_rating_count
        : null;
      const first_release_date = item.first_release_date
        ? new Date(item.first_release_date * 1000)
        : null;
      const name = item.name ? item.name : null;
      const rating = item.rating ? parseFloat(item.rating).toFixed(2) : null;
      const rating_count = item.rating_count ? item.rating_count : null;
      const storyline = item.storyline ? item.storyline : null;
      const summary = item.summary ? item.summary : null;
      const total_rating = item.total_rating
        ? parseFloat(item.total_rating).toFixed(2)
        : null;
      const total_rating_count = item.total_rating_count
        ? item.total_rating_count
        : null;
      const version_title = item.version_title ? item.version_title : null;
      const collection = item.collection ? item.collection : null;
      const created_at = item.created_at
        ? new Date(item.created_at * 1000)
        : null;

      const request = new sql.Request(pool);
      request.input("game", sql.Int, game);

      // Verificar si el juego ya existe en la base de datos
      let checkQuery = `SELECT COUNT(*) AS count FROM Game WHERE game = @game`;
      let checkResult = await request.query(checkQuery);

      if (checkResult.recordset[0].count === 0) {
        request.input(
          "aggregated_rating",
          sql.Decimal(5, 2),
          aggregated_rating
        );
        request.input(
          "aggregated_rating_count",
          sql.Int,
          aggregated_rating_count
        );
        request.input("first_release_date", sql.Date, first_release_date);
        request.input("name", sql.NVarChar, name);
        request.input("rating", sql.Decimal(5, 2), rating);
        request.input("rating_count", sql.Int, rating_count);
        request.input("storyline", sql.NVarChar, storyline);
        request.input("summary", sql.NVarChar, summary);
        request.input("total_rating", sql.Decimal(5, 2), total_rating);
        request.input("total_rating_count", sql.Int, total_rating_count);
        request.input("version_title", sql.NVarChar, version_title);
        request.input("collection", sql.Int, collection);
        request.input("created_at", sql.Date, created_at);

        // Verificar si la colección existe en la bd
        checkQuery = `SELECT COUNT(*) AS count FROM Collection WHERE collection = @collection`;
        checkResult = await request.query(checkQuery);
        if (checkResult.recordset[0].count === 0) {
          console.log(`Coleccion no encontrada: ID ${collection}`);
          request.input("collection", sql.Int, null);
        }
        const query = `INSERT INTO Game 
                (game, aggregated_rating, aggregated_rating_count, first_release_date, name, rating, rating_count, storyline, summary, total_rating, total_rating_count, version_title, created_at, collection) 
                VALUES (@game, @aggregated_rating, @aggregated_rating_count, @first_release_date, @name, @rating, @rating_count, @storyline, @summary, @total_rating, @total_rating_count, @version_title, @created_at, @collection)`;
        await request.query(query);

        console.log(`Insertado el juego: ID ${game}, Nombre ${name}`);
      } else {
        console.log(`Juego duplicado encontrado: ID ${game}, Nombre ${name}`);
      }
    }
    return 1;
  } catch (error) {
    console.error("Error al insertar datos:", error);
    return 0;
  }
}

async function insertCollection(data, pool) {
  try {
    for (const item of data) {
      const collection = item.id;
      const name = item.name;
      const request = new sql.Request(pool);
      request.input("collection", sql.Int, collection);

      // Verificar si el juego ya existe en la base de datos
      const checkQuery = `SELECT COUNT(*) AS count FROM Collection WHERE collection = @collection`;
      const checkResult = await request.query(checkQuery);

      if (checkResult.recordset[0].count === 0) {
        request.input("name", sql.NVarChar, name);

        const query = `INSERT INTO Collection (collection, name) VALUES (@collection, @name)`;
        await request.query(query);

        console.log(`Insertado la collecion: ID ${collection}, Nombre ${name}`);
      } else {
        console.log(
          `Colección duplicado encontrado: ID ${collection}, Nombre ${name}`
        );
      }
    }
    return 1;
  } catch (error) {
    console.error("Error al insertar datos:", error);
    return 0;
  }
}

async function main() {
  try {
    const pool = await sql.connect(config);

    while (true) {
      const data = await obtenerData();
      if (data.length === 0) break; // Si la lista viene vacía se termina el while
      const exito = await insertMuchosAMuchos(data, pool);
      if (!exito) break;
      cont += 500;

      // Agregar un retraso para no sobrecargar la API
      await new Promise((resolve) => setTimeout(resolve, 1000));
      console.log("cont: ", cont);
    }
    console.log("Se han insertado todos los datos correctamente.");
  } catch (error) {
    console.error("Error principal:", error);
  } finally {
    sql.close();
  }
}

main();
