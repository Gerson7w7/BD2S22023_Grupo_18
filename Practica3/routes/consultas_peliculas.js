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
            ProjectionExpression: 'Titulo'
        };
        dynamoDocumentClient.scan(params, (err, data) => {
            if (err) {
                res.status(500).json({ error: 'Error al obtener las peliculas.' });
            } else {
                console.log("Títulos de películas disponibles:", data.Items);
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
                console.log("Películas con clasificación R o superior:", data.Items);
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
                res.json(data.Items);
            }
        });
    } catch (err) {
        console.log(err);
        res.status(500).json({ error: 'Error al obtener las peliculas' });
    }
});

module.exports = router;