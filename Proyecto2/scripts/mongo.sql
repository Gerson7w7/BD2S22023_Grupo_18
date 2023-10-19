db.Game.find()

-- CONSULTA 3 
-- Storede Procedure que reciba un parametro el jeugo, que busque y muestre la 
-- información y agrupe por plataforma.
const juegoPorPlataforma = function (juegoBuscado) {
    return db.Games.aggregate([
        {
        $match: {
            name: juegoBuscado
        }
        },
        {
        $unwind: "$platforms"
        },
        {
        $group: {
            _id: "$platforms.name",
            juegos: {
            $addToSet: "$name"
            }
        }
        },
        {
        $project: {
            _id: 0,
            plataforma: "$_id",
            juegos: 1
        }
        }
    ]);
}

db.system.js.insertOne({
    _id: 'juegoPorPlataforma',
    value: juegoPorPlataforma
});

juegoPorPlataforma("Counterside")

-- CONSULTA 6
-- Realizar un stored procedure que reciba de parámetro el nombre del juego o ID del mismo y que 
-- despliegue toda la información relacionada con la misma.
const informacionJuego = function (juego) {
    return db.Games.find({name: juego})
}

db.system.js.insertOne({
    _id: 'informacionJuego',
    value: informacionJuego
});

informacionJuego("Counterside")