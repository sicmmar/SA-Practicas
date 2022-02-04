const jwt = require("jsonwebtoken");
const express = require("express");
const fs = require("fs");
const http = require("http");
const { TK_RES, TK_CLI } = require("../tk_sha");
const { response } = require("express");
const app = express();
app.use(express.json());

const server = http.createServer(app);
const puerto = 7053;

app.get("/", (req, res) => {
  res.send("Jau");
});

// realizar pedido
app.post("/", (req, res) => {
  const { token, pedido } = req.body;

  try {
    jwt.verify(token, TK_CLI);

    fs.appendFile(
        "../logs.sicmmar",
        new Date(Date.now()).toUTCString() +
          "\t\tPedido realizado.\n",
        (err) => {}
      );
      res.send({ mensaje: "Pedido solicitado al restaurante." });
    
  } catch (err) {
    fs.appendFile(
      "../logs.sicmmar",
      new Date(Date.now()).toUTCString() +
        "\t\tRol no permitido para realizar pedido.\n",
      (err) => {}
    );
    res.status(401).send({ mensaje: "Credenciales incorrectas." });
  }
});

server.listen(puerto, () => {
  console.log(`Servidor corriendo en el puerto ${puerto}`);
});
