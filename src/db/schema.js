import {
  mysqlTable,
  int,
  varchar,
  char,
  boolean,
  date,
  decimal,
} from "drizzle-orm/mysql-core";

export const usCitizens = mysqlTable("US_CITIZENS", {
  id: int("ID").primaryKey().autoincrement(),
  idCity: int("ID_CITY").notNull(),
  idState: int("ID_STATE").notNull(),
  firstName: varchar("FIRST_NAME", { length: 50 }).notNull(),
  lastName: varchar("LAST_NAME", { length: 50 }).notNull(),
  gender: char("GENDER", { length: 1 }).notNull(),
  birthdate: date("BIRTHDATE").notNull(),
  married: boolean("MARRIED").notNull(),
  ssn: varchar("SSN", { length: 11 }).notNull(),
  income: decimal("INCOME", { precision: 12, scale: 2 }).notNull(),
  citizenship: varchar("CITIZENSHIP", { length: 10 }).notNull().default("US"),
});

export const usStates = mysqlTable("US_STATES", {
  id: int("ID").primaryKey().autoincrement(),
  stateName: varchar("STATE_NAME", { length: 50 }).notNull(),
  stateAbbreviation: char("STATE_ABBREVIATION", { length: 2 }).notNull(),
});

export const usCities = mysqlTable("US_CITIES", {
  id: int("ID").primaryKey().autoincrement(),
  idState: int("ID_STATE").notNull(),
  cityName: varchar("CITY_NAME", { length: 50 }).notNull(),
  cityPopulation: int("CITY_POPULATION").notNull(),
});
