const jwt = require('jsonwebtoken');

function respuesta(codigo, datos) {
  return {
    statusCode: codigo,
    headers: {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
    },
    body: JSON.stringify(datos),
  };
}

function leerUsuario(event) {
  const encabezado = event.headers.Authorization || event.headers.authorization;
  if (!encabezado) {
    return null;
  }

  const token = encabezado.replace('Bearer ', '');
  try {
    return jwt.verify(token, process.env.JWT_SECRET);
  } catch (error) {
    return null;
  }
}

function esPersonalDe(usuario, idCafeteria) {
  return usuario && usuario.rol === 'cafeteria' && usuario.id_cafeteria === idCafeteria;
}

module.exports = { respuesta, leerUsuario, esPersonalDe };
