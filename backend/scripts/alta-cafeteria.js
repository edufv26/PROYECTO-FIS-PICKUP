const bcrypt = require('bcryptjs');
const pool = require('../src/db');

async function main() {
  const [nombre, correo, password, idCafeteria] = process.argv.slice(2);

  if (!nombre || !correo || !password || !idCafeteria) {
    console.log('Uso: npm run alta-cafeteria -- "Nombre" correo password ID_CAFETERIA');
    process.exit(1);
  }

  const hash = await bcrypt.hash(password, 10);
  await pool.query(
    `INSERT INTO usuarios (nombre_completo, correo_institucional, password_hash, rol, id_cafeteria)
     VALUES ($1, $2, $3, 'cafeteria', $4)`,
    [nombre, correo.trim().toLowerCase(), hash, idCafeteria]
  );

  console.log('Personal de cafetería dado de alta: ' + correo);
  await pool.end();
}

main().catch((error) => {
  console.log('Error: ' + error.message);
  process.exit(1);
});
