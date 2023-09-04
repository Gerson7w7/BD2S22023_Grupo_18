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
  } catch (error) {
    console.error('Error al insertar datos:', error);
  }
}

async function main() {
  try {
    const pool = await sql.connect(config);

    while (true) {
      const data = await obtenerData();
      if (data.length === 0) break; // Si la lista viene vacía se termina el while
      await insertCollection(data, pool);
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
