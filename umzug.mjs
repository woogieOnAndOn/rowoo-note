import { Umzug } from 'umzug';
import mysql from 'mysql2/promise';
import path from 'path';
import fs from  'fs';
import dotenv from 'dotenv';

dotenv.config();

const getRawSqlClient = async () => {
	const options = {
		host: process.env.MYSQL_HOST,
		port: process.env.MYSQL_PORT,
		user: process.env.MYSQL_USER,
		password: process.env.MYSQL_ROOT_PASSWORD,
		database: process.env.MYSQL_DATABASE,
	};

	const connection = await mysql.createConnection(options);

	return {
		query: async (sql, values) => connection.query(sql, values),
	};	
}

export const migrator = new Umzug({
	migrations: {
		glob: 'migrations/*.sql',
		resolve(params) {
			const downPath = path.join(path.dirname(params.path), 'down', path.basename(params.path));
			return {
				name: params.name,
				path: params.path,
				up: async () => params.context.query(fs.readFileSync(params.path).toString()),
				down: async () => params.context.query(fs.readFileSync(downPath).toString()),
			};
		},
	},
	context: getRawSqlClient(),
	storage: {
		async executed({ context: client }) {
			await client.query(`create table if not exists my_migrations_table(name text)`);
			const [results] = await client.query(`select name from my_migrations_table`);
			return results.map((r) => r.name);
		},
		async logMigration({ name, context: client }) {
			await client.query(`insert into my_migrations_table(name) values (?)`, [name]);
		},
		async unlogMigration({ name, context: client }) {
			await client.query(`delete from my_migrations_table where name = ?`, [name]);
		},
	},
	logger: console,
	create: {
		folder: 'migrations',
	},
});

const migrateType = process.argv[2];
let response;
if (migrateType === 'clean') {
	const connection = await getRawSqlClient();
	const deleteDatabaseResult = await connection.query('DROP DATABASE note', []);
	if (deleteDatabaseResult[0].affectedRows > 0) {
		response = await connection.query('CREATE DATABASE note', []);
	}
} else {
	response = await migrator.runAsCLI([migrateType]);
}

process.exit(response);