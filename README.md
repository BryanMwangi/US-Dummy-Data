# US-Dummy-Data

This is a repo that contains 29880 registered cities in the United States and has a script that inserts dummy citizens that do not exist.

The 2 SQL file contains 3 tables:

- US_STATES: ID, STATE_CODE and STATE_NAME.

- US_CITIES: ID, ID_STATE, CITY, COUNTY, LATITUDE and LONGITUDE.

- US_CITIZENS: ID, ID_CITY, ID_STATE, FIRST_NAME, LAST_NAME, GENDER, BIRTHDATE, MARRIED, SSN, INCOME, CITIZENSHIP.

The US_CITIES table has all (or almost all) cities from the **United States**.

## Compatibility

Both sql files are compatible with MySQL.

### US_STATES

| ID  | STATE_CODE | STATE_NAME |
| :-: | :--------: | :--------: |
|  1  |     AL     |  Alabama   |
|  2  |     AK     |   Alaska   |
|  3  |     AZ     |  Arizona   |

### US_CITIES

| ID  | ID_STATE |   CITY   |     COUNTY     | LATITUDE  | LONGITUDE  |
| :-: | :------: | :------: | :------------: | :-------: | :--------: |
|  1  |    2     |   Adak   | Aleutians West | 55.999722 | -161.20777 |
|  2  |    2     | Akiachak |     Bethel     | 60.891854 | -161.39233 |
|  3  |    2     |  Akiak   |     Bethel     | 60.890632 | -161.19932 |
|  4  |    2     |  Akutan  | Aleutians East | 54.143012 | -165.78536 |
|  5  |    2     | Alakanuk |    Kusilvak    | 62.746967 | -164.60228 |

### US_CITIZENS

| ID  | ID_CITY | ID_STATE | FIRST_NAME | LAST_NAME | GENDER | BIRTHDATE  | MARRIED | SSN         | INCOME   | CITIZENSHIP |
| --- | ------- | -------- | ---------- | --------- | ------ | ---------- | ------- | ----------- | -------- | ----------- |
| 1   | 1       | 1        | James      | Stein     | M      | 1980-01-01 | true    | 123-45-6789 | 55000.00 | US          |
| 2   | 3       | 2        | Carole     | Stone     | F      | 1975-05-20 | false   | 987-65-4321 | 72000.00 | US          |
| 3   | 6       | 4        | Adam       | Smith     | M      | 1990-12-15 | false   | 555-66-7777 | 64000.00 | US          |
| 4   | 2       | 1        | Maria      | Lopez     | F      | 1988-08-08 | true    | 111-22-3333 | 58000.00 | US          |
| 5   | 4       | 3        | John       | Doe       | M      | 1965-03-10 | true    | 444-55-6666 | 80000.00 | US          |

## Getting Started

To get started, you need to have a MySQL database running. You can use the following command to create a new database:

```bash
mysql -u root -p
```

Or use docker:

```bash
docker run --name citizens-mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=my-secure-password -d mysql:oraclelinux9
```

Once you have a database running, you can create the tables and insert the data by running the following command:

```bash
mysql -u root -p US_DUMMY_DATA < us_dummy_data.sql

mysql -u root -p US_DUMMY_DATA < us_citizens.sql
```

You can also use the [us_dummy_data.sql](./us_dummy_data.sql) file to create the database and tables.

Once the tables are created, you can run first install the dependencies by running the following command:

```bash
npm install
```

Once the dependencies are installed, you can run the [index.js](./src/index.js) file to insert the dummy citizens into the database.

```bash
node src/index.js
```

or

```bash
npm run start
```

The script will seed the citizens table with a random population of citizens for each city in the US. Current min and max population is 50 and 200. You can change these values in the [index.js](./src/index.js) file.

## Contributing

Contributions are welcome! Please open an issue or a pull request if you find any inconsistencies or errors in the data.

## License

This project was created under the [MIT license][1].

If you find some inconsistent data, such as a duplicated city, please open an issue explaining what is happening or directly fix the problem and send a Pull Request.

## References

This repo was inspired by the following repo:
[https://github.com/kelvins/US-Cities-Database.git][2]

This original dump was created based on the SQL dump that can be found at the following link:
[http://www.farinspace.com/us-cities-and-state-sql-dump/][2]
