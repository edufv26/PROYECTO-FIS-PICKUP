const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const pool = require('./db');
const { respuesta, leerUsuario } = require('./utils');

const DOMINIO = '@tese.edu.mx';

async function registro(event) {
  const { nombre, correo, matricula, password } = JSON.parse(event.body || '{}');

  if (!nombre || !correo || !matricula || !password) {
    return respuesta(400, { error: 'Faltan datos' });
  }

  const correoLimpio = correo.trim().toLowerCase();
  const usuarioCorreo = correoLimpio.replace(DOMINIO, '');

  if (!correoLimpio.endsWith(DOMINIO) || usuarioCorreo.length === 0) {
    return respuesta(400, { error: 'Solo se permiten correos ' + DOMINIO });
  }

  if (password.length < 6) {
    return respuesta(400, { error: 'La contraseña debe tener al menos 6 caracteres' });
  }

  const existe = await pool.query(
    'SELECT id_usuario FROM usuarios WHERE correo_institucional = $1 OR matricula = $2',
    [correoLimpio, matricula]
  );
  if (existe.rows.length > 0) {
    return respuesta(409, { error: 'El correo o la matrícula ya están registrados' });
  }

  const hash = await bcrypt.hash(password, 10);
  await pool.query(
    `INSERT INTO usuarios (nombre_completo, correo_institucional, matricula, password_hash, rol)
     VALUES ($1, $2, $3, $4, 'estudiante')`,
    [nombre, correoLimpio, matricula, hash]
  );

  return respuesta(201, { mensaje: 'Usuario registrado' });
}

async function login(event) {
  const { correo, password } = JSON.parse(event.body || '{}');

  if (!correo || !password) {
    return respuesta(400, { error: 'Faltan datos' });
  }

  const resultado = await pool.query(
    'SELECT * FROM usuarios WHERE correo_institucional = $1',
    [correo.trim().toLowerCase()]
  );
  const usuario = resultado.rows[0];

  if (!usuario || !(await bcrypt.compare(password, usuario.password_hash))) {
    return respuesta(401, { error: 'Correo o contraseña incorrectos' });
  }

  const token = jwt.sign(
    { id: usuario.id_usuario, rol: usuario.rol, id_cafeteria: usuario.id_cafeteria },
    process.env.JWT_SECRET,
    { expiresIn: '8h' }
  );

  return respuesta(200, {
    token,
    nombre: usuario.nombre_completo,
    rol: usuario.rol,
    id_cafeteria: usuario.id_cafeteria,
  });
}

async function perfil(event) {
  const usuario = leerUsuario(event);
  if (!usuario) {
    return respuesta(401, { error: 'Token inválido o vencido' });
  }

  const resultado = await pool.query(
    `SELECT id_usuario, nombre_completo, correo_institucional, matricula, rol, id_cafeteria
     FROM usuarios WHERE id_usuario = $1`,
    [usuario.id]
  );

  return respuesta(200, resultado.rows[0]);
}

module.exports = { registro, login, perfil };
