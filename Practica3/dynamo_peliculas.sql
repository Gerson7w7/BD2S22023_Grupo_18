// Listar todas las películas disponibles.
const params = {
    TableName: 'peliculas',
    ProjectionExpression: 'Titulo'
};
  
dynamodb.scan(params, (err, data) => {
    if (err) {
        console.error("Error al escanear la tabla:", err);
    } else {
        console.log("Títulos de películas disponibles:", data.Items);
    }
});

// Buscar películas por género (por ejemplo, Comedia).
const params2 = {
    TableName: 'peliculas',
    FilterExpression: 'Genero = :genero',
    ExpressionAttributeValues: { ':genero': 'Comedia' }
};
  
dynamodb.scan(params2, (err, data) => {
    if (err) {
      console.error("Error al escanear la tabla:", err);
    } else {
      console.log("Películas de Comedia:", data.Items);
    }
});

// Mostrar películas con una clasificación R (restringida) o superior.
const params3 = {
    TableName: 'peliculas', // Reemplaza 'peliculas' con el nombre de tu tabla en DynamoDB
    FilterExpression: 'Clasificacion = :clasificacion',
    ExpressionAttributeValues: { ':clasificacion': 'R' }
};

dynamodb.scan(params3, (err, data) => {
    if (err) {
        console.error("Error al escanear la tabla:", err);
    } else {
        console.log("Películas con clasificación R o superior:", data.Items);
    }
});

// Encontrar películas dirigidas por un director específico.
const params4 = {
    TableName: 'peliculas', // Reemplaza 'peliculas' con el nombre de tu tabla en DynamoDB
    FilterExpression: 'Director = :director',
    ExpressionAttributeValues: { ':director': 'James Cameron' }
};

dynamodb.scan(params4, (err, data) => {
    if (err) {
        console.error("Error al escanear la tabla:", err);
    } else {
        console.log("Películas dirigidas por James Cameron:", data.Items);
    }
});

// Buscar películas con un precio inferior a 15
const params5 = {
    TableName: 'peliculas', // Reemplaza 'peliculas' con el nombre de tu tabla en DynamoDB
    FilterExpression: 'Precio < :precio',
    ExpressionAttributeValues: { ':precio': 15 }
};

dynamodb.scan(params5, (err, data) => {
    if (err) {
        console.error("Error al escanear la tabla:", err);
    } else {
        console.log("Películas con precio inferior a 15:", data.Items);
    }
});