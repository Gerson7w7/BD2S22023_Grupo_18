// Listar todos los libros disponibles
const params1 = {
  TableName: 'libros',
  ProjectionExpression: 'Titulo'
};

dynamodb.scan(params1, (error, data) => {
  if (error) {
    console.error("Error:", error);
  } else {
    console.log("Libros:", data.Items);
  }
});

// Encontrar libros por Categoria (por ejemplo, Ciencia Ficción)
const params2 = {
  TableName: 'libros',
  FilterExpression: '#categoria = :categoria',
  ExpressionAttributeNames: { '#categoria': 'Categoria' },
  ExpressionAttributeValues: { ':categoria': 'Ciencia Ficción' }
};

dynamodb.scan(params2, (error, data) => {
  if (error) {
    console.error("Error:", error);
  } else {
    console.log("Libros:", data.Items);
  }
});

// Buscar libros con un autor específico
const params3 = {
  TableName: 'libros',
  FilterExpression: '#autor = :autor',
  ExpressionAttributeNames: { '#autor': 'Autor' },
  ExpressionAttributeValues: { ':autor': 'George Orwell' }
};

dynamodb.scan(params3, (error, data) => {
  if (error) {
    console.error("Error:", error);
  } else {
    console.log("Libros:", data.Items);
  }
});


// Mostrar los libros ordenados por calificación promedio (de mayor a menor)


// Encontrar libros con un precio inferior a 20.
const params5 = {
  TableName: 'libros',
  FilterExpression: '#stock < :valor',
  ExpressionAttributeNames: { '#stock': 'Stock' },
  ExpressionAttributeValues: { ':valor': 20 }
};

dynamodb.scan(params5, (error, data) => {
  if (error) {
    console.error("Error:", error);
  } else {
    console.log("Libros:", data.Items);
  }
});

// Buscar libros con una palabra clave en el título o descripción.
const params6 = {
  TableName: 'libros',
  FilterExpression: 'contains(#titulo, :keyword) or contains(#descripcion, :keyword)',
  ExpressionAttributeNames: { '#titulo': 'Titulo', '#descripcion': 'Descripcion' },
  ExpressionAttributeValues: { ':keyword': 'cien' }
};

dynamodb.scan(params6, (error, data) => {
  if (error) {
    console.error("Error:", error);
  } else {
    console.log("Libros:", data.Items);
  }
});

// Información de los 10 autores más caros (Suma del precio de todos sus libros)


// Obtener la cantidad de libros en stock para un libro específico
const params8 = {
  TableName: 'libros',
  KeyConditionExpression: '#titulo = :titulo',
  ExpressionAttributeNames: { '#titulo': 'Titulo' },
  ExpressionAttributeValues: { ':titulo': 'Matar a un ruiseñor' },
  ProjectionExpression: 'Stock'
};

dynamodb.query(params8, (error, data) => {
  if (error) {
    console.error("Error:", error);
  } else {
    console.log("Stock:", data.Items[0].Stock);
  }
});

// Calcular el precio promedio de todos los libros


// Información de todas las categorías.
