import { last_names, first_names } from "./names/names.js";
import { usCitizens } from "./db/schema.js";
import { db } from "./db/db.js";

const POPULATION_LIMIT_MAX = 200;
const POPULATION_LIMIT_MIN = 50;

const randomFirstName = () =>
  first_names[Math.floor(Math.random() * first_names.length)];

const randomLastName = () =>
  last_names[Math.floor(Math.random() * last_names.length)];

const randomGender = () => (Math.random() < 0.5 ? "M" : "F");

const randomMarried = () => Math.random() < 0.5;

const randomIncome = () => Math.floor(Math.random() * (100000 - 30000)) + 30000;

const randomSSN = () => {
  const part1 = Math.floor(Math.random() * 900 + 100);
  const part2 = Math.floor(Math.random() * 90 + 10);
  const part3 = Math.floor(Math.random() * 9000 + 1000);
  return `${part1}-${part2}-${part3}`;
};

const randomBirthday = () => {
  const min = new Date(1940, 0, 1).getTime();
  const max = new Date(2005, 0, 1).getTime();
  const date = new Date(min + Math.random() * (max - min));
  return date.toISOString().slice(0, 10);
};

const randomPopulation = () => {
  return (
    Math.floor(Math.random() * (POPULATION_LIMIT_MAX - POPULATION_LIMIT_MIN)) +
    POPULATION_LIMIT_MIN
  );
};

async function main() {
  try {
    const [cities] = await db.execute("SELECT ID, ID_STATE FROM US_CITIES");
    for (const city of cities) {
      const population = randomPopulation();
      const citizens = [];

      for (let i = 0; i < population; i++) {
        citizens.push({
          idCity: city.ID,
          idState: city.ID_STATE,
          firstName: randomFirstName(),
          lastName: randomLastName(),
          gender: randomGender(),
          birthdate: randomBirthday(),
          married: randomMarried(),
          ssn: randomSSN(),
          income: randomIncome(),
          citizenship: "US",
        });
      }

      await db.insert(usCitizens).values(citizens);
      console.log(`Inserted ${population} citizens for city ID ${city.ID}`);
    }

    console.log("✅ Seeding complete.");
  } catch (error) {
    console.error(error);
  } finally {
    process.exit(0);
  }
}

main();
