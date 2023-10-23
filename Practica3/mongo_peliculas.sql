// Listar todas las películas disponibles.
db.peliculas.find({}, {Titulo: 1})

// Buscar películas por género (por ejemplo, Comedia).
db.peliculas.find({Genero: "Drama"})

// Mostrar películas con una clasificación R (restringida) o superior.
db.peliculas.find({Clasificacion: { $in: ["R", "A"] }})

// Encontrar películas dirigidas por un director específico.
db.peliculas.find({Director: "James Cameron"})

// Buscar películas con un precio inferior a 15
db.peliculas.find({Precio: { $lt: 15 }})