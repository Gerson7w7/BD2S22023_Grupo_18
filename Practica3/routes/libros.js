const router = require("express").Router();
const { clientMongoDB } = require("../configs/mongodb.config");

router.get("/ver", async (req, res) => {
  try {
    // Conectar al servidor de MongoDB
    await clientMongoDB.connect();
    // Seleccionar la base de datos "Libros"
    const database = clientMongoDB.db("Libros");
    // Acceder a la colección "Libro"
    const coleccionLibro = database.collection("Libro");
    // Obtener los documentos de la colección "Libro"
    const documentos = await coleccionLibro.find({}).toArray();
    // Cerrar la conexión al finalizar
    await clientMongoDB.close();

    res.json(documentos);
  } catch {
    // Cerrar la conexión al finalizar
    await clientMongoDB.close();
    res.status(400);
  }
});

router.post("/crear", async (req, res) => {
  try {
    await clientMongoDB.connect();
    const database = clientMongoDB.db("Libros");
    const coleccionLibro = database.collection("Libro");

    // Datos del nuevo libro
    const nuevoLibro = req.body;

    // Añadir el nuevo libro a la colección
    const resultado = await coleccionLibro.insertOne(nuevoLibro);
    // Cerrar la conexión al finalizar
    await clientMongoDB.close();
    res.json({ mensaje: "Nuevo libro añadido", libro: resultado });
  } catch (error) {
    // Cerrar la conexión al finalizar
    console.log(error);
    await clientMongoDB.close();
    res.status(400);
  }
});

router.put("/editar/:id", async (req, res) => {
  try {
    await clientMongoDB.connect();
    const database = clientMongoDB.db("Libros");
    const coleccionLibro = database.collection("Libro");

    const libroId = req.params.id; // Obtener el ID del libro de los parámetros de la URL
    const datosActualizados = req.body; // Nuevos datos para el libro
    // Actualizar el libro por su ID
    const resultado = await coleccionLibro.updateOne(
      { Id: Number(libroId) }, // Filtrar por el ID
      { $set: datosActualizados } // Establecer los nuevos datos
    );

    if (resultado.modifiedCount === 1) {
      console.log("Libro editado con éxito");
      res.json({ mensaje: "Libro editado con éxito" });
    } else {
      console.error("No se pudo encontrar o editar el libro");
      res.status(404).json({ mensaje: resultado });
    }
  } catch (error) {
    console.error("Error al editar el libro:", error);
    res.status(500).json({ mensaje: "Error al editar el libro" });
  } finally {
    await clientMongoDB.close();
  }
});

router.delete("/eliminar/:id", async (req, res) => {
  try {
    await clientMongoDB.connect();
    const database = clientMongoDB.db("Libros");
    const coleccionLibro = database.collection("Libro");

    const idLibro = req.params.id; // Obtener el valor de miId de los parámetros de la URL

    // Eliminar el libro por su miId
    const resultado = await coleccionLibro.deleteOne({ Id: Number(idLibro) });

    if (resultado.deletedCount === 1) {
      console.log("Libro eliminado con éxito");
      res.json({ mensaje: "Libro eliminado con éxito" });
    } else {
      console.error("No se pudo encontrar el libro para eliminar");
      res
        .status(404)
        .json({ mensaje: "No se pudo encontrar el libro para eliminar" });
    }
  } catch (error) {
    console.error("Error al eliminar el libro:", error);
    res.status(500).json({ mensaje: "Error al eliminar el libro" });
  } finally {
    await clientMongoDB.close();
  }
});

module.exports = router;
