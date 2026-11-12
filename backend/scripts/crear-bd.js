const fs = require('fs');
const path = require('path');
const { Client } = require('pg');
const { config } = require('../src/db');

const archivos = [
  '../../database/schema.sql',
  '../database/cambios_backend.sql',
  '../database/datos_prueba.sql',
];

async function main() {
  const servidor = new Client({ ...config, database: 'postgres' });
  await servidor.connect();
  await servidor.query('DROP DATABASE IF EXISTS ' + config.database);
  await servidor.query('CREATE DATABASE ' + config.database);
  await servidor.end();

  const bd = new Client(config);
  await bd.connect();
  for (const archivo of archivos) {
    const sql = fs.readFileSync(path.join(__dirname, archivo), 'utf8');
    await bd.query(sql);
    console.log('Ejecutado: ' + path.basename(archivo));
  }
  await bd.end();

  console.log('Base de datos ' + config.database + ' lista');
}

main().catch((error) => {
  console.log('Error: ' + error.message);
  process.exit(1);
});
