const pool = require('./db');
const { respuesta, leerUsuario, esPersonalDe } = require('./utils');

const ESTADOS = ['PENDIENTE', 'EN_PREPARACION', 'LISTO', 'ENTREGADO'];

async function verPedidos(event) {
  const idCafeteria = event.pathParameters.id;
  const usuario = leerUsuario(event);

  if (!esPersonalDe(usuario, idCafeteria)) {
    return respuesta(403, { error: 'Solo el personal de esta cafetería puede ver los pedidos' });
  }

  const resultado = await pool.query(
    `SELECT pe.id_pedido::text AS id,
            u.nombre_completo AS "alumnoNombre",
            u.matricula,
            pe.total::float AS total,
            pe.fecha_pedido AS "horaPedido",
            pe.estado,
            COALESCE(array_agg(d.cantidad || 'x ' || pr.nombre) FILTER (WHERE d.id_detalle IS NOT NULL), '{}') AS items
     FROM pedidos pe
     JOIN usuarios u ON u.id_usuario = pe.id_usuario
     LEFT JOIN detalle_pedido d ON d.id_pedido = pe.id_pedido
     LEFT JOIN productos pr ON pr.id_producto = d.id_producto
     WHERE pe.id_cafeteria = $1 AND pe.estado <> 'ENTREGADO'
     GROUP BY pe.id_pedido, u.nombre_completo, u.matricula
     ORDER BY pe.fecha_pedido`,
    [idCafeteria]
  );

  return respuesta(200, resultado.rows);
}

async function cambiarEstado(event) {
  const idCafeteria = event.pathParameters.id;
  const idPedido = event.pathParameters.pid;
  const usuario = leerUsuario(event);

  if (!esPersonalDe(usuario, idCafeteria)) {
    return respuesta(403, { error: 'Solo el personal de esta cafetería puede cambiar pedidos' });
  }

  const { estado } = JSON.parse(event.body || '{}');
  if (!ESTADOS.includes(estado)) {
    return respuesta(400, { error: 'Estado no válido' });
  }

  const resultado = await pool.query(
    'UPDATE pedidos SET estado = $1 WHERE id_pedido::text = $2 AND id_cafeteria = $3',
    [estado, idPedido, idCafeteria]
  );

  if (resultado.rowCount === 0) {
    return respuesta(404, { error: 'Pedido no encontrado' });
  }

  return respuesta(200, { mensaje: 'Estado actualizado' });
}

module.exports = { verPedidos, cambiarEstado };
