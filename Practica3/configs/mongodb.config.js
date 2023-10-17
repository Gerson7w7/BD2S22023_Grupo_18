const { MongoClient } = require("mongodb");
require("dotenv").config();

const uri = `mongodb+srv://${process.env.USER_MONGODB}:${process.env.PASSWORD_MONGODB}@cluster0.p93vnfs.mongodb.net/?retryWrites=true&w=majority`;
const clientMongoDB = new MongoClient(uri, {
  serverApi: {
    version: "1",
    strict: true,
    deprecationErrors: true,
  },
});

async function run() {
  try {
    // Connect the client to the server (optional starting in v4.7)
    await clientMongoDB.connect();
    // Send a ping to confirm a successful connection
    await clientMongoDB.db("admin").command({ ping: 1 });
    console.log(
      "Pinged your deployment. You successfully connected to MongoDB!"
    );
  } finally {
    // Ensures that the client will close when you finish/error
    await clientMongoDB.close();
  }
}

run().catch(console.dir);

module.exports = { clientMongoDB };
