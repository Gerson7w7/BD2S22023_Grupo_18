// Listar todos los libros disponibles
db.libros.find({}, {Titulo:1})

// Encontrar libros por Categoria (por ejemplo, Ciencia Ficción)
db.libros.find({ "Categoria": "Ficción" })

// Buscar libros con un autor específico
db.libros.find({ "Autor": "George Orwell" })

// Mostrar los libros ordenados por calificación promedio (de mayor a menor)
db.libros.find().sort({ "Calificacion": -1 })

// Encontrar libros con un precio inferior a 20.
db.libros.find({ "Stock": { $lt: 30 } })

// Buscar libros con una palabra clave en el título o descripción.
db.libros.find({
  $or: [
    { "Titulo": { $regex: "cien", $options: "i" } },
    { "Descripcion": { $regex: "novela", $options: "i" } }
  ]
})

// Información de los 10 autores más caros (Suma del precio de todos sus libros)
db.libros.aggregate([
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
db.libros.find({ "Titulo": "Matar a un ruiseñor" }, { "Stock": 1, _id: 0 })

// Calcular el precio promedio de todos los libros
db.libros.aggregate([
  {
    $group: {
      _id: null,
      PrecioPromedio: { $avg: "$Precio" }
    }
  }
])

// Información de todas las categorías.
db.libros.distinct("Categoria")