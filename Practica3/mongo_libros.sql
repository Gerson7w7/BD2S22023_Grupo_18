// Listar todos los libros disponibles
db.Libro.find({}, {Titulo:1})

// Encontrar libros por Categoria (por ejemplo, Ciencia Ficción)
db.Libro.find({ "Categoria": "Ficción" })

// Buscar libros con un autor específico
db.Libro.find({ "Autor": "George Orwell" })

// Mostrar los libros ordenados por calificación promedio (de mayor a menor)
db.Libro.find().sort({ "Calificacion": -1 })

// Encontrar libros con un precio inferior a 20.
db.Libro.find({ "Precio": { $lt: 30 } })

// Buscar libros con una palabra clave en el título o descripción.
db.Libro.find({
  $or: [
    { "Titulo": { $regex: "cien", $options: "i" } },
    { "Descripcion": { $regex: "novela", $options: "i" } }
  ]
})

// Información de los 10 autores más caros (Suma del precio de todos sus libros)
db.Libro.aggregate([
  {
    $group: {
      _id: "$Autor",
      PrecioTotal: { $sum: "$Precio" }
    }
  },
  {
    $sort: { PrecioTotal: -1 }
  },
  {
    $limit: 10
  }
])

// Obtener la cantidad de libros en stock para un libro específico
db.Libro.find({ "Titulo": "Matar a un ruiseñor" }, { "Stock": 1, _id: 0 })

// Calcular el precio promedio de todos los libros
db.Libro.aggregate([
  {
    $group: {
      _id: null,
      PrecioPromedio: { $avg: "$Precio" }
    }
  }
])

// Información de todas las categorías.
db.Libro.aggregate([
  {
    $group: {
      _id: "$Categoria",
      libros: { $push: {
          Titulo: "$Titulo",
          Autor: "$Autor",
          Descripcion: "$Descripcion",
          FechaDePublicacion: "$FechaDePublicacion",
          Calificacion: "$Calificacion",
          Stock: "$Stock",
          Precio: "$Precio",
      }}
    }
  }
])