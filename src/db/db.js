import mysql from "mysql2/promise";
import { drizzle } from "drizzle-orm/mysql2";

const poolConnection = mysql.createPool({
  host: "localhost",
  user: "my-user",
  password: "my-password",
  database: "US_DUMMY_DATA",
  waitForConnections: true,
  connectionLimit: 10,
});

export const db = drizzle(poolConnection);
