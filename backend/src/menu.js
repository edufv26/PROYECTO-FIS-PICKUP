const pool = require('./db');
const { respuesta, leerUsuario, esPersonalDe } = require('./utils');

async function verMenu(event) {
  const idCafeteria = event.pathParameters.id;

  const resultado = await pool.query(
    `SELECT p.id_producto::text AS id, p.nombre, c.nombre AS categoria,
            p.precio::float AS precio, p.disponible
     FROM productos p
     JOIN categorias c ON c.id_categoria = p.id_categoria
     WHERE p.id_cafeteria = $1
     ORDER BY p.id_producto`,
    [idCafeteria]
  );

  return respuesta(200, resultado.rows);
}

async function guardarPlatillo(event) {
  const idCafeteria = event.pathParameters.id;
  const usuario = leerUsuario(event);

  if (!esPersonalDe(usuario, idCafeteria)) {
    return respuesta(403, { error: 'Solo el personal de esta cafetería puede editar el menú' });
  }

  const { id, nombre, categoria, precio, disponible } = JSON.parse(event.body || '{}');

  if (!nombre || !categoria || precio == null) {
    return respuesta(400, { error: 'Faltan datos' });
  }

  let cat = await pool.query('SELECT id_categoria FROM categorias WHERE nombre = $1', [categoria]);
  if (cat.rows.length === 0) {
    cat = await pool.query('INSERT INTO categorias (nombre) VALUES ($1) RETURNING id_categoria', [categoria]);
  }
  const idCategoria = cat.rows[0].id_categoria;

  const actualizado = await pool.query(
    `UPDATE productos SET nombre = $1, id_categoria = $2, precio = $3, disponible = $4
     WHERE id_producto::text = $5 AND id_cafeteria = $6`,
    [nombre, idCategoria, precio, disponible !== false, String(id), idCafeteria]
  );

  if (actualizado.rowCount === 0) {
    await pool.query(
      `INSERT INTO productos (id_categoria, id_cafeteria, nombre, precio, disponible)
       VALUES ($1, $2, $3, $4, $5)`,
      [idCategoria, idCafeteria, nombre, precio, disponible !== false]
    );
    return respuesta(201, { mensaje: 'Platillo creado' });
  }

  return respuesta(200, { mensaje: 'Platillo actualizado' });
}

module.exports = { verMenu, guardarPlatillo };
