import * as dotenv from 'dotenv';
import env = require('env-var');

dotenv.config({ path: '.env' });

export const secretConfig = {
  infuraApiKey: env.get('INFURA_API_KEY').required(true).asString(),
  etherscanApiKey: env.get('ETHERSCAN_API_KEY').required(true).asString(),
  coinmarketcapApiKey: env.get('COINMARKETCAP_API_KEY').required(true).asString(),
  contractOwnerPrivateKey: env.get('CONTRACT_OWNER_PRIVATE_KEY').required(true).asString(),
};

export const basicConfig = {
  reportGas: env.get('REPORT_GAS').required(false).asBool(),
};

export const supportExternalNetworkChainIds = [
  1, // eth mainnet
  3, // ropsten testnet
];
