const jwt = require("jsonwebtoken");
const express = require("express");
const fs = require("fs");
const http = require("http");
const { TK_RES, TK_CLI } = require("../tk_sha");
const { response } = require("express");
const app = express();
app.use(express.json());

const server = http.createServer(app);
const puerto = 7051;
const URL_RES = "http://localhost:7053/";
const URL_REP = "http://localhost:7057/";

app.get("/", (req, res) => {
  res.send("Jau");
});

// solicitar pedido al restaurante
app.post("/", (req, res) => {
  const { token, pedido } = req.body;

  try {
    const key = jwt.verify(token, TK_CLI);

    // solicitud al restaurante
    fetch(URL_RES, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: {
        pedido: pedido,
        token: token,
      },
    })
      .then((response) => response.json())
      .then((data) => {
        fs.appendFile(
          "../logs.sicmmar",
          new Date(Date.now()).toUTCString() +
            "\t\tPedido solicitado al restaurante.\n",
          (err) => {}
        );
        res.send({ mensaje: "Pedido solicitado al restaurante." });
      }).catch((error) => {
          console.log(error)
      });
    
  } catch (err) {
    fs.appendFile(
      "../logs.sicmmar",
      new Date(Date.now()).toUTCString() +
        "\t\tRol no permitido para solicitar pedido al restaurante.\n",
      (err) => {}
    );
    res.status(401).send({ mensaje: "Credenciales incorrectas." });
  }
});

server.listen(puerto, () => {
  console.log(`Servidor corriendo en el puerto ${puerto}`);
});
