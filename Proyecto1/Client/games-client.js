const fetch = require('node-fetch');
const sql = require('mssql');

const url = "https://api.igdb.com/v4";
let cont = 0;
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

async function obtenerData() {
  try {
    const response = await fetch(
      `${url}/collections`,
      {
        method: 'POST',
        headers: {
          'Accept': 'application/json',
          'Client-ID': '0ufnhiamg15efiwfbt755uwdpyz5ke',
          'Authorization': 'Bearer nmkfbuwbnkkwd5o0p56z6k53u5me6e',
        },
        body: `fields *; limit 500; offset 0; sort id asc; where id >= ${cont};`
      }
    );

    const data = await response.json();
    return data;
  } catch (error) {
    throw new Error('Error al obtener datos:', error);
  }
}

async function insertPlatform(data, pool) {
  // 2623
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
    return 1
  } catch (error) {
    console.error("Error al insertar datos:", error);
    return 0
  }
}

async function insertGenre(data, pool) {
  // 2623
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
        console.log(
          `Genero duplicado encontrado: ID ${genre}, Nombre ${name}`
        );
      }
    }
    return 1
  } catch (error) {
    console.error("Error al insertar datos:", error);
    return 0
  }
}

async function insertGame(data, pool) {
  // 2623
  try {
    for (const item of data) {
      const game = item.id;
      const aggregated_rating = item.aggregated_rating ? parseFloat(item.aggregated_rating).toFixed(2) : null;
      const aggregated_rating_count = item.aggregated_rating_count ? item.aggregated_rating_count : null;
      const first_release_date = item.first_release_date ? new Date(item.first_release_date * 1000) : null;
      const name = item.name ? item.name : null;
      const rating = item.rating ? parseFloat(item.rating).toFixed(2) : null;
      const rating_count = item.rating_count ? item.rating_count : null;
      const storyline = item.storyline ? item.storyline : null;
      const summary = item.summary ? item.summary : null;
      const total_rating = item.total_rating ? parseFloat(item.total_rating).toFixed(2) : null;
      const total_rating_count = item.total_rating_count ? item.total_rating_count: null;
      const version_title = item.version_title ? item.version_title: null;
      const collection = item.collection ? item.collection: null;
      const created_at = item.created_at ? new Date(item.created_at * 1000) : null;

      const request = new sql.Request(pool);
      request.input("game", sql.Int, game);

      // Verificar si el juego ya existe en la base de datos
      let checkQuery = `SELECT COUNT(*) AS count FROM Game WHERE game = @game`;
      let checkResult = await request.query(checkQuery);

      if (checkResult.recordset[0].count === 0) {
        request.input("aggregated_rating", sql.Decimal(5,2), aggregated_rating);
        request.input("aggregated_rating_count", sql.Int, aggregated_rating_count);
        request.input("first_release_date", sql.Date, first_release_date);
        request.input("name", sql.NVarChar, name);
        request.input("rating", sql.Decimal(5,2), rating);
        request.input("rating_count", sql.Int, rating_count);
        request.input("storyline", sql.NVarChar, storyline);
        request.input("summary", sql.NVarChar, summary);
        request.input("total_rating", sql.Decimal(5,2), total_rating);
        request.input("total_rating_count", sql.Int, total_rating_count);
        request.input("version_title", sql.NVarChar, version_title);
        request.input("collection", sql.Int, collection);
        request.input("created_at", sql.Date, created_at);

        // Verificar si la colección existe en la bd
        checkQuery = `SELECT COUNT(*) AS count FROM Collection WHERE collection = @collection`;
        checkResult = await request.query(checkQuery);
        if (checkResult.recordset[0].count === 0) {
          console.log(
            `Coleccion no encontrada: ID ${collection}`
          );
          request.input("collection", sql.Int, null);
        }
        const query = `INSERT INTO Game 
                (game, aggregated_rating, aggregated_rating_count, first_release_date, name, rating, rating_count, storyline, summary, total_rating, total_rating_count, version_title, created_at, collection) 
                VALUES (@game, @aggregated_rating, @aggregated_rating_count, @first_release_date, @name, @rating, @rating_count, @storyline, @summary, @total_rating, @total_rating_count, @version_title, @created_at, @collection)`;
        await request.query(query);

        console.log(`Insertado el juego: ID ${game}, Nombre ${name}`);
      } else {
        console.log(
          `Juego duplicado encontrado: ID ${game}, Nombre ${name}`
        );
      }
    }
    return 1
  } catch (error) {
    console.error("Error al insertar datos:", error);
    return 0
  }
}

async function insertCollection(data, pool) {
  try {
    for (const item of data) {
      const collection = item.id;
      const name = item.name;
      const request = new sql.Request(pool);
      request.input('collection', sql.Int, collection);

      // Verificar si el juego ya existe en la base de datos
      const checkQuery = `SELECT COUNT(*) AS count FROM Collection WHERE collection = @collection`;
      const checkResult = await request.query(checkQuery);

      if (checkResult.recordset[0].count === 0) {     
        request.input('name', sql.NVarChar, name);

        const query = `INSERT INTO Collection (collection, name) VALUES (@collection, @name)`;
        await request.query(query);

        console.log(`Insertado la collecion: ID ${collection}, Nombre ${name}`);
      } else {
        console.log(`Colección duplicado encontrado: ID ${collection}, Nombre ${name}`);
      }
    }
    return 1
  } catch (error) {
    console.error('Error al insertar datos:', error);
    return 0
  }
}

async function main() {
  try {
    const pool = await sql.connect(config);

    while (true) {
      const data = await obtenerData();
      if (data.length === 0) break; // Si la lista viene vacía se termina el while
      const exito = await insertCollection(data, pool);
      if (!exito) break; 
      cont += 500;

      // Agregar un retraso para no sobrecargar la API
      await new Promise(resolve => setTimeout(resolve, 1000));
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
