const express = require("express");
const libros = require("./routes/libros");
const app = express();
const port = 3000;

app.use(express.json());
app.use('/libros', libros);

app.listen(port, () => {
  console.log(`App listening on port ${port}`);
});
