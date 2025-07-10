import mysql from "mysql2/promise";
import { drizzle } from "drizzle-orm/mysql2";

const poolConnection = mysql.createPool({
  host: "localhost",
  user: "app_user",
  password: "pass123",
  database: "US_DUMMY_DATA",
  waitForConnections: true,
  connectionLimit: 10,
});

export const db = drizzle(poolConnection);
