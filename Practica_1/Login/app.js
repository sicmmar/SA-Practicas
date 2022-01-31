const express = require("express");
const http = require("http");
const app = express();

const server = http.createServer(app);
const puerto = 7050;

app.get("/", (req, res) => {
    res.send("Jau");
});

app.post("/", (req, res) => {

});

server.listen(puerto, () => {
    console.log(`Servidor corriendo en el puerto ${puerto}`);
})