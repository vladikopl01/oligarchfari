import * as dotenv from 'dotenv';
import env = require('env-var');

dotenv.config({ path: '.env' });

export const envConfig = {
  infuraApiKey: env.get('INFURA_API_KEY').asString(),
  etherscanApiKey: env.get('ETHERSCAN_API_KEY').asString(),
  coinmarketcapApiKey: env.get('COINMARKETCAP_API_KEY').asString(),
  walletPrivateKey: env.get('WALLET_PRIVATE_KEY').asString(),
  reportGas: env.get('REPORT_GAS').default('false').asBool(),
};

export const supportChainIds = [
  1313161554, // mainnet
  1313161555, // testnet
];
