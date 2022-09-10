const path = require('path');
const marv = require('marv/api/promise'); // <-- Promise API
const driver = require('marv-mysql-driver');
const directory = path.resolve('migrations');
require('dotenv').config();
const connection = {
  // Properties are passed straight pg.Client
  host: process.env.MYSQL_HOST,
  port: process.env.MYSQL_PORT,
  user: process.env.MYSQL_USER,
  password: process.env.MYSQL_ROOT_PASSWORD,
  database: process.env.MYSQL_DATABASE,
};

const startMigrate = async () => {
  const migrations = await marv.scan(directory);
  await marv.migrate(migrations, driver({ connection }));
}

startMigrate();