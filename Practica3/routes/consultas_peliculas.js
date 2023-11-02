const router = require("express").Router();
const AWS = require('aws-sdk');

AWS.config.update({
    region: process.env.REGION,
    accessKeyId: process.env.ACCESS_KEY_ID,
    secretAccessKey: process.env.SECRET_ACCESS_KEY
});

const dynamoDocumentClient = new AWS.DynamoDB.DocumentClient();
//const dynamoDocumentClient = new AWS.DynamoDB();

// Listar todas las películas disponibles.
router.get("/consulta1", async (req, res) => {
    try {
        const params = {
            TableName: 'Peliculas',
            //ProjectionExpression: 'Titulo'
        };
        dynamoDocumentClient.scan(params, (err, data) => {
            if (err) {
                res.status(500).json({ error: 'Error al obtener las peliculas.' });
            } else {
                res.json(data.Items);
            }
        });
    } catch (err) {
        console.log(err);
        res.status(500).json({ error: 'Error al obtener las peliculas' });
    }
});

// Buscar películas por género (por ejemplo, Comedia).
router.get("/consulta2/:genero", async (req, res) => {
    try {
        const genero = req.params.genero;
        const params2 = {
            TableName: 'Peliculas',
            FilterExpression: 'Genero = :genero',
            ExpressionAttributeValues: { ':genero': genero }
        };
          
        dynamoDocumentClient.scan(params2, (err, data) => {
            if (err) {
              console.error("Error al escanear la tabla:", err);
              res.status(500).json({ error: 'Error al obtener las peliculas.' });
            } else {
              console.log(`Películas de ${genero}:`, data.Items);
              res.json(data.Items);
            }
        });
    } catch (err) {
        console.log(err);
        res.status(500).json({ error: 'Error al obtener las peliculas' });
    }
});

// Mostrar películas con una clasificación R (restringida) o superior.
router.get("/consulta3", async (req, res) => {
    try {
        const params3 = {
            TableName: 'Peliculas',
            FilterExpression: 'Clasificacion = :clasificacion',
            ExpressionAttributeValues: { ':clasificacion': 'R' }
        };
        
        dynamoDocumentClient.scan(params3, (err, data) => {
            if (err) {
                console.error("Error al escanear la tabla:", err);
                res.status(500).json({ error: 'Error al obtener las peliculas.' });
            } else {
                res.json(data.Items);
            }
        });
    } catch (err) {
        console.log(err);
        res.status(500).json({ error: 'Error al obtener las peliculas' });
    }
});

// Encontrar películas dirigidas por un director específico.
router.get("/consulta4/:director", async (req, res) => {
    try {
        const director = req.params.director;
        const params4 = {
            TableName: 'Peliculas',
            FilterExpression: 'Director = :director',
            ExpressionAttributeValues: { ':director': director }
        };
        
        dynamoDocumentClient.scan(params4, (err, data) => {
            if (err) {
                console.error("Error al escanear la tabla:", err);
                res.status(500).json({ error: 'Error al obtener las peliculas.' });
            } else {
                console.log(`Películas dirigidas por ${director}:`, data.Items);
                res.json(data.Items);
            }
        });
    } catch (err) {
        console.log(err);
        res.status(500).json({ error: 'Error al obtener las peliculas' });
    }
});

// Buscar películas con un precio inferior a 15
router.get("/consulta5/:precio", async (req, res) => {
    try {
        const precio = req.params.precio;
        const params5 = {
            TableName: 'Peliculas', // Reemplaza 'peliculas' con el nombre de tu tabla en DynamoDB
            FilterExpression: 'Precio < :precio',
            ExpressionAttributeValues: { ':precio': Number(precio) }
        };
        
        dynamoDocumentClient.scan(params5, (err, data) => {
            if (err) {
                console.error("Error al escanear la tabla:", err);
                res.status(500).json({ error: 'Error al obtener las peliculas.' });
            } else {
                console.log(`Películas con precio inferior a ${precio}:`, data.Items);
                res.json(data.Items);
            }
        });
    } catch (err) {
        console.log(err);
        res.status(500).json({ error: 'Error al obtener las peliculas' });
    }
});

// Recuperar películas lanzadas en un año específico (por ejemplo, 2022).
router.get("/consulta6/:year", async (req, res) => {
    try {
        const year = req.params.year;
        const params = {
            TableName: 'Peliculas',
            FilterExpression: 'begins_with(FechaDeEstreno,  :valor)',
            ExpressionAttributeValues: {
                ':valor': year,
            },
        };
        dynamoDocumentClient.scan(params, (err, data) => {
            if(err) {
                console.log(err);
                res.status(500).json({ error: 'Error al obtener las peliculas.' });
            } else {
                res.status(200).json(data.Items);
            }
        });
    } catch (err) {
        console.log(err);
        res.status(500).json({ error: 'Error al obtener las peliculas' });
    }
});

//Información de los 10 directores con mejor calificación (Promedio de todas sus películas)
router.get("/consulta7", async (req, res) => {
    try {
        const params = {
            TableName: 'Peliculas',
            ProjectionExpression: 'Director, Calificacion'
        };
        dynamoDocumentClient.scan(params, (err, data) => {
            if(err) {
                console.log(err);
                res.status(500).json({ error: 'Error al obtener los directores.' });
            } else {
                const directorCalificaciones = {};

                // Itera a través de los resultados y agrupa las calificaciones por director
                data.Items.forEach(item => {
                    const director = item.Director;
                    const calificacion = Number(item.Calificacion);
                
                    if (directorCalificaciones[director]) {
                        directorCalificaciones[director].calificaciones.push(calificacion);
                    } else {
                        directorCalificaciones[director] = {
                            calificaciones: [calificacion]
                        };
                    }
                });

                // Calcula el promedio de calificación para cada director
                const directorPromedios = {};
                for (const director in directorCalificaciones) {
                    const calificaciones = directorCalificaciones[director].calificaciones;
                    const promedio = calificaciones.reduce((suma, elemento) => suma + elemento, 0) / calificaciones.length;
                    directorPromedios[director] = promedio;
                }

                // Ordena a los directores por su promedio de calificación en orden descendente
                const directoresOrdenados = Object.keys(directorPromedios).sort(
                    (a, b) => directorPromedios[b] - directorPromedios[a]
                );
            
                const lista = [];
                for (const director of directoresOrdenados.slice(0, 10)) {
                    lista.push({Director: director, Promedio: directorPromedios[director]});
                }
                
                res.status(200).json(lista);
            }
        });
    } catch (err) {
        console.log(err);
        res.status(500).json({ error: 'Error al obtener los directores' });
    }
});

//Buscar películas con una palabra clave en el título o descripción
router.get("/consulta8/:word", async (req, res) => {
    try {
        const word = req.params.word;
        const params = {
            TableName: 'Peliculas',
            FilterExpression: 'contains(Titulo,  :valor) or contains(Descripcion, :valor)',
            ExpressionAttributeValues: {
                ':valor': word,
            },
        };
        dynamoDocumentClient.scan(params, (err, data) => {
            if(err) {
                console.log(err);
                res.status(500).json({ error: 'Error al obtener las peliculas.' });
            } else {
                res.status(200).json(data.Items);
            }
        });
    } catch (err) {
        console.log(err);
        res.status(500).json({ error: 'Error al obtener las peliculas' });
    }
});

//Calcular el precio promedio de todas las películas.
router.get("/consulta9", async (req, res) => {
    try {
        const params = {
            TableName: 'Peliculas',
            ProjectionExpression: 'Precio'
        };
        dynamoDocumentClient.scan(params, (err, data) => {
            if(err) {
                console.log(err);
                res.status(500).json({ error: 'Error al obtener las peliculas.' });
            } else {
                const items = data.Items;
                if (items.length === 0) {
                    res.status(200).json({mensaje:'No existen películas registradas.'})
                } else {
                    const totalPrecios = items.reduce((sum, item) => sum + item.Precio, 0);
                    const precioPromedio = totalPrecios / items.length;
                    res.status(200).json({PrecioPromedio: precioPromedio});
                }
            }
        });
    } catch (err) {
        console.log(err);
        res.status(500).json({ error: 'Error al obtener las peliculas' });
    }
});

//Encontrar películas con las mejores calificaciones promedio (ordenadas de mayor a menor).
router.get("/consulta10", async (req, res) => {
    try {
        const params = {
            TableName: 'Peliculas'
        };
        dynamoDocumentClient.scan(params, (err, data) => {
            if(err) {
                console.log(err);
                res.status(500).json({ error: 'Error al obtener las peliculas.' });
            } else {
                const orden = data.Items.sort((a, b) => b.Calificacion - a.Calificacion)
                res.status(200).json(orden);
            }
        });
    } catch (err) {
        console.log(err);
        res.status(500).json({ error: 'Error al obtener las peliculas' });
    }
});

module.exports = router;