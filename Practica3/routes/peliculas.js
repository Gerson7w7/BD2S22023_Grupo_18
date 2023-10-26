const router = require('express').Router();
const AWS = require('aws-sdk');

AWS.config.update({
    region: process.env.REGION,
    accessKeyId: process.env.ACCESS_KEY_ID,
    secretAccessKey: process.env.SECRET_ACCESS_KEY
});

const dynamoDocumentClient = new AWS.DynamoDB.DocumentClient();

router.get("/ver", async (req, res) => {
  try {
    const params = { 
      TableName: 'Peliculas'
    };
    dynamoDocumentClient.scan(params, (err, data) => {
        if(err) {
          console.log(err);
          res.status(500).json({ error: 'Error al obtener las peliculas' });
        } else {
          res.json(data.Items);
        }
    });
  } catch (err) {
    console.log(err);
    res.status(500).json({ error: 'Error al obtener las peliculas' });
  }
});

router.post("/crear", async (req, res) => {
  try {
    const newMovie = req.body;
    const params = {
      TableName: 'Peliculas',
      Item: newMovie
    }
    dynamoDocumentClient.put(params, (err, data) => {
      if (err) {
        console.log(err);
        res.status(500).json({ error: 'Error al insertar la nueva película.' });
      } else {
        res.status(200).json({ mensaje: 'Nueva película añadida.' });
      }
    });
  } catch (err) {
    console.log(err);
    res.status(500).json({ error: 'Error al insertar la nueva película.' });
  }
});

router.put("/editar/:id", async (req, res) => {
  try {
    const movieId = req.params.id;
    const paramsBusqueda = {
      TableName: 'Peliculas',
      Key: {
        'Pelicula': movieId
      }
    }
    dynamoDocumentClient.get(paramsBusqueda, (err, data) => {
      if(err) {
        console.log(err);
      } else {
        if (Object.keys(data).length > 0) {
          const data = req.body;
          // Actualizar película por su nombre
          const updateExpression = 'SET ' + Object.keys(data).map(attr => `#${attr} = :${attr}`).join(', ');
          expressionAttributeNames = Object.keys(data).reduce((acc, attr) => {
            acc[`#${attr}`] = attr;
            return acc;
          }, {});
          expressionAttributeValues = Object.keys(data).reduce((acc, attr) => {
            acc[`:${attr}`] = data[attr];
            return acc;
          }, {});

          const params = { 
            TableName: 'Peliculas',
            Key: {
              'Pelicula': movieId
            },
            UpdateExpression: updateExpression,
            ExpressionAttributeNames: expressionAttributeNames,
            ExpressionAttributeValues: expressionAttributeValues
          };
          
          dynamoDocumentClient.update(params, (err, data) => {
              if(err) {
                console.log(err);
                res.status(500).json({ error: 'Error al actualizar la película con ID: ' + movieId });
              } else {
                res.status(200).json({ mensaje: `Película con ID: ${movieId} actualizada con éxito.` });
              }
          });
        } else {
          res.status(400).json({ error: 'No existe la película que se intenta actualizar.' });
        }
      }
    });
  } catch (err) {
    console.log(err)
    res.status(500).json({ error: 'Error al actualizar la película con ID: ' + req.params.id });
  }
});

router.delete("/eliminar/:id", async (req, res) => {
  try {
    const params = { 
      TableName: 'Peliculas',
      Key: {
        'Pelicula': req.params.id
      }
    };
    dynamoDocumentClient.get(params, (err, data) => {
      if(err) {
        console.log(err);
      } else {
        if (Object.keys(data).length > 0) {
          dynamoDocumentClient.delete(params, (err, data) => {
            if(err) {
              console.log(err);
              res.status(500).json({ error: 'Error al eliminar la película con ID: ' + req.params.id });
            } else {
              res.status(200).json({ mensaje: `Película con ID: ${req.params.id} eliminada con éxito.` });
            }
          });
        } else {
          res.status(400).json({ error: 'No existe la película que se intenta eliminar.' });
        }
      }
    });
  } catch (err) {
    console.log(err)
    res.status(500).json({ error: 'Error al eliminar la película con ID: ' + req.params.id });
  }
});

module.exports = router;