# Hardhat-Typescript setup template

## Tech Stack

**Main:** Hardhat, Typescript, openzeppelin/contracts, openzeppelin/contracts-upgradeable

**Hardhat plugins:** ethers, typechain, hardhat-gas-reporter, openzeppelin/hardhat-upgrades

**Testing:** mocha, chai, waffle

**Others:** eslint, prettier, solhint, lint-staged, pretty-quick, dotenv, env-var, husky

## Installation

Install dependencies

```bash
  npm install
```

## Environment Variables

To run this project, you will need to add the following environment variables to your `.env` file

`INFURA_API_KEY={INFURA_API_KEY}, required`

`ETHERSCAN_API_KEY={ETHERSCAN_API_KEY}, required`

`COINMARKETCAP_API_KEY={COINMARKETCAP_API_KEY}, required`

`CONTRACT_OWNER_PRIVATE_KEY={CONTRACT_OWNER_PRIVATE_KEY}, required`

`REPORT_GAS={true or false}`

## Running Tests

To run tests, run the following command

```bash
  npm run test
```
