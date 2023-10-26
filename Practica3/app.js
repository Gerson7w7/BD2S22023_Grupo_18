const express = require("express");
const libros = require("./routes/libros");
const peliculas = require('./routes/peliculas');
const consultasPeliculas = require('./routes/consultas_peliculas');
const app = express();
const port = 3000;

app.use(express.json());
app.use('/libros', libros);
app.use('/peliculas', peliculas);
app.use('/consultas-peliculas', consultasPeliculas);

app.listen(port, () => {
  console.log(`App listening on port ${port}`);
});
