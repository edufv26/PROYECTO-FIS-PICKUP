const { Pool } = require('pg');

const config = {
  host: 'localhost',
  port: 5432,
  user: 'postgres',
  password: 'postgres',
  database: 'tese_pickup',
};

const pool = new Pool(config);

module.exports = pool;
module.exports.config = config;
