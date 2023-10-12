const fs = require("fs");

// Función para leer un archivo JSON
function readJSONFile(filename, callback) {
  fs.readFile(filename, "utf8", (err, data) => {
    if (err) {
      console.error(`Error al leer el archivo ${filename}:`, err);
      callback(err, null);
      return;
    }

    try {
      const jsonData = JSON.parse(data);
      callback(null, jsonData);
    } catch (error) {
      console.error(`Error al parsear el archivo ${filename}:`, error);
      callback(error, null);
    }
  });
}

// Función para escribir un archivo JSON
function writeJSONFile(filename, data, callback) {
  fs.writeFile(filename, JSON.stringify(data, null, 2), "utf8", (err) => {
    if (err) {
      console.error(`Error al escribir en el archivo ${filename}:`, err);
      callback(err);
    } else {
      console.log(`Archivo ${filename} actualizado correctamente.`);
      callback(null);
    }
  });
}

// Función para procesar los géneros
function processGenres(genresData, gameData, genreData) {
  genresData.Genres.forEach((genre) => {
    const foundGame = gameData.Game.find((g) => g.game === genre.game);
    if (foundGame) {
      const foundGenre = genreData.Genre.find((g) => g.genre === genre.genre);

      if (foundGenre) {
        foundGame.genres = foundGame.genres || [];
        foundGame.genres.push(foundGenre);
        console.log(
          `Género con ID ${genre.genre} agregado al juego con ID ${genre.game}`
        );
      } else {
        console.log(`No se encontró el género con ID ${genre.genre}`);
      }
    } else {
      console.log(`No se encontró el juego con ID ${genre.game}`);
    }
  });

  writeJSONFile("./outputJsons/game.json", gameData, (err) => {
    if (!err) {
      console.log('Campo "genres" agregado a game.json correctamente.');
    }
  });
}

// Función para procesar los involvedcompany
function processInvolvedCompany(involvedCompanyData, companyData) {
  involvedCompanyData.InvolvedCompany.forEach((involvedCompany) => {
    const foundCompany = companyData.Company.find(
      (c) => c.company === involvedCompany.company
    );
    if (foundCompany) {
      involvedCompany.company = foundCompany;
      console.log(
        `Compañía con ID ${foundCompany.company} agregada al InvolvedCompany con ID ${involvedCompany.involved_company}`
      );
    } else {
      console.log(`No se encontró el juego con ID ${genre.game}`);
    }
  });

  writeJSONFile(
    "./outputJsons/involvedcompany.json",
    involvedCompanyData,
    (err) => {
      if (!err) {
        console.log(
          'Campo "company" agregado a involvedcompany.json correctamente.'
        );
      }
    }
  );
}

// Función para procesar los involvedcompanies
function processInvolvedCompanies(
  involvedCompaniesData,
  gameData,
  involvedCompanyData
) {
  involvedCompaniesData.InvolvedCompanies.forEach((i) => {
    const foundGame = gameData.Game.find((g) => g.game === i.game);
    if (foundGame) {
      const foundInvolvedCompany = involvedCompanyData.InvolvedCompany.find(
        (ic) => ic.involved_company === i.involved_company
      );

      if (foundInvolvedCompany) {
        foundGame.involved_companies = foundGame.involved_companies || [];
        foundGame.involved_companies.push(foundInvolvedCompany);
        console.log(
          `InvolvedCompany con ID ${i.involved_company} agregado al juego con ID ${i.game}`
        );
      } else {
        console.log(
          `No se encontró el InvolvedCompany con ID ${i.involved_company}`
        );
      }
    } else {
      console.log(`No se encontró el juego con ID ${i.game}`);
    }
  });

  writeJSONFile("./outputJsons/game.json", gameData, (err) => {
    if (!err) {
      console.log(
        'Campo "involved_company" agregado a game.json correctamente.'
      );
    }
  });
}

function limpiar(gameData) {
  gameData.Game.forEach((game) => {
    delete game.involved_companies;
  });

  writeJSONFile("./outputJsons/game.json", gameData, (err) => {
    if (!err) {
      console.log(
        'Campo "involved_companies" eliminado de game.json correctamente.'
      );
    }
  });
}

// Leer el archivo 'games.json'
// readJSONFile("../jsons/Game.json", (err, data1) => {
//   if (!err) {
//     limpiar(data1);
//   }
// });

// Leer el archivo 'genres.json'
readJSONFile("../jsons/InvolvedCompanies.json", (err, data1) => {
  if (!err) {
    // Leer el archivo 'game.json'
    readJSONFile("./outputJsons/game.json", (err, data2) => {
      if (!err) {
        // processInvolvedCompany(data1, data2);
        // Leer el archivo 'genre.json'
        readJSONFile("./outputJsons/involvedcompany.json", (err, data3) => {
          if (!err) {
            // Procesar los géneros
            processInvolvedCompanies(data1, data2, data3);
          }
        });
      }
    });
  }
});
