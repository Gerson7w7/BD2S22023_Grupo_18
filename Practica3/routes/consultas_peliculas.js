const router = require("express").Router();
const AWS = require('aws-sdk');

AWS.config.update({
    region: process.env.REGION,
    accessKeyId: process.env.ACCESS_KEY_ID,
    secretAccessKey: process.env.SECRET_ACCESS_KEY
});

const dynamoDocumentClient = new AWS.DynamoDB.DocumentClient();
//const dynamoDocumentClient = new AWS.DynamoDB();

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