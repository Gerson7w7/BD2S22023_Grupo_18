show dbs;

use Videojuegos

db.createCollection("games")
db.createCollection("genres")
db.createCollection("platforms")

show collections

db.games.find({})
db.games.count()

db.games.find({}, { name: 1, platforms: 1, rating: 1, genres: 1 }).sort({ rating: -1 }).limit(100)

// ----------------------------------------- CONSULTA 1 -----------------------------------------
// Vista que muestre el top 100 de los juegos evaluado por Rating o
// valoración según el sitio web. (nombre, plataforma, rating, genero)
db.createView("top_rated_games", "games", [
  {
    $project: {
      _id: 0,
      name: 1,
      platforms: 1,
      rating: 1,
      genres: 1,
    }
  },
  {
    $sort: {
      rating: -1
    }
  },
  {
    $limit: 100
  }
])

db.top_rated_games.find()


// ----------------------------------------- CONSULTA 2 -----------------------------------------
// Stored procedure (funcion en este caso) que reciba un parámetro alfanumérico para
// buscar juegos por nombre (palabras o aproximaciones).

const searchGamesByName = function (searchTerm) {
    const regex = new RegExp(searchTerm, "i");
    return db.games.find({ name: { $regex: regex } });
}

db.system.js.insertOne({
  _id: 'searchGamesByName',
  value: searchGamesByName
});

searchGamesByName("Thief");

// ----------------------------------------- CONSULTA 3 -----------------------------------------
// Stored procedure (funcion en este caso) que reciba un parámetro el juego, que busque y
// muestre la información y agrupe por plataforma.

const juegoPorPlataforma = function (gameName) {
    const game = db.games.findOne({ name: gameName });

    if (game) {
      return db.games.aggregate([
        {
          $match: { name: gameName }
        },
        {
          $unwind: "$platforms"
        },
        {
          $group: {
            _id: "$platforms.name",
            games: {
              $push: {
                name: "$name",
                rating: "$rating",
                genres: "$genres"
              }
            }
          }
        }
      ]);
    } else {
      return "Juego no encontrado.";
    }
}

db.system.js.insertOne({
  _id: "juegoPorPlataforma",
  value: juegoPorPlataforma
});

juegoPorPlataforma("Call of Duty: Black Ops");


// ----------------------------------------- CONSULTA 4 -----------------------------------------
// Vista que muestre el top 100 de juegos que soporten más idiomas
// (subtítulos y audio) ordenados por rating, nombre y que idiomas soportan.


db.createView("juego_lenguajes", "games", [
  {
    $unwind: "$language_support"
  },
  {
    $group: {
      _id: "$_id",
      name: { $first: "$name" },
      rating: { $first: "$rating" },
      languages: {
        $addToSet: {
          language: "$language_support.language.name",
          native_name: "$language_support.language.native_name",
          language_support_type: "$language_support.language_support_type.name"
        }
      }
    }
  },
  {
    $project: {
      _id: 0,
      name: 1,
      rating: 1,
      numLanguages: { $size: "$languages" },
      languages: 1
    }
  },
  {
    $sort: {
      numLanguages: -1,
      rating: -1,
      name: 1
    }
  },
  {
    $limit: 100
  }
]);

db.juego_lenguajes.find();


// ----------------------------------------- CONSULTA 5 -----------------------------------------
// Consulta que muestre el top los juegos por genero, ordenados por rating

db.games.aggregate([
  {
    $match: {
      "genres.name": "Shooter"
    }
  },
  {
    $project: {
      _id: 0,
      name: 1,
      rating: 1
    }
  },
  {
    $sort: { rating: -1 }
  },
  {
    $limit: 100
  }
])



// ----------------------------------------- CONSULTA 6 -----------------------------------------
// Realizar un stored procedure que reciba de parámetro el nombre del juego o ID del mismo y que
// despliegue toda la información relacionada con la misma.


const informacionJuego = function (game) {
   var juego = null;

   if (typeof game === 'string') {
     juego = db.games.findOne({ "name": game });
   } else if (typeof game === 'number') {
     juego = db.games.findOne({ "game": game });
   }

   if (juego) {
     for (var key in juego) {
       if (juego.hasOwnProperty(key)) {
         var value = juego[key];
         if (typeof value === 'object') {
           print(key + ": " + JSON.stringify(value));
         } else {
           print(key + ": " + value);
         }
       }
     }
   } else {
     print("Juego no encontrado.");
   }
}

informacionJuego("Call of Duty: Black Ops");


