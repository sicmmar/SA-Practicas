const tks = require("../tk_sha");
const jwt = require("jsonwebtoken");
const express = require("express");
const http = require("http");
const fs = require("fs");
const app = express();
app.use(express.json());

const server = http.createServer(app);
const puerto = 7050;

app.get("/", (req, res) => {
  res.send("Jau");
});

// login
app.post("/", (req, res) => {
  const { usuario } = req.body;
  let respuesta = {
    user: usuario,
    token: "",
  };

  if (usuario == "usuarioCliente") {
    respuesta.token = jwt.sign(
      {
        id: usuario,
      },
      tks.TK_CLI,
      {
        expiresIn: "1h",
      }
    );
    fs.appendFile(
      "../logs.sicmmar",
      new Date(Date.now()).toUTCString() +
        "\t\tInicio de sesión de cliente exitoso\n",
      (err) => {}
    );
  } else if (usuario == "usuarioRestaurante") {
    respuesta.token = jwt.sign(
      {
        id: usuario,
      },
      tks.TK_RES,
      {
        expiresIn: "1h",
      }
    );

    fs.appendFile(
      "../logs.sicmmar",
      new Date(Date.now()).toUTCString() +
        "\t\tInicio de sesión de restaurante exitoso\n",
      (err) => {}
    );
  } else if (usuario == "usuarioRepartidor") {
    respuesta.token = jwt.sign(
      {
        id: usuario,
      },
      tks.TK_REP,
      {
        expiresIn: "1h",
      }
    );

    fs.appendFile(
      "../logs.sicmmar",
      new Date(Date.now()).toUTCString() +
        "\t\tInicio de sesión de repartidor exitoso\n",
      (err) => {}
    );
  }

  if (respuesta.token == "") {
    fs.appendFile(
      "../logs.sicmmar",
      new Date(Date.now()).toUTCString() + "\t\tInicio de sesión no exitoso\n",
      (err) => {}
    );
    res.status(404).send({ mensaje: "Credenciales incorrectas." });
  }

  res.send(respuesta);
});

server.listen(puerto, () => {
  console.log(`Servidor corriendo en el puerto ${puerto}`);
});
