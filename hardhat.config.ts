import '@nomiclabs/hardhat-ethers';
import '@nomiclabs/hardhat-etherscan';
import '@nomiclabs/hardhat-solhint';
import '@nomiclabs/hardhat-waffle';
import '@typechain/ethers-v5';
import '@typechain/hardhat';
import 'hardhat-gas-reporter';

import { HardhatUserConfig } from 'hardhat/types';
import { envConfig } from './utils/config';

const config: HardhatUserConfig = {
  solidity: '0.8.16',
  networks: {
    hardhat: {},
    aurora: {
      chainId: 1313161554,
      url: `https://aurora-mainnet.infura.io/v3/${envConfig.infuraApiKey}`,
    },
    testnet: {
      chainId: 1313161555,
      url: `https://aurora-testnet.infura.io/v3/${envConfig.infuraApiKey}`,
    },
  },
  typechain: {
    outDir: 'typechain',
    target: 'ethers-v5',
  },
  etherscan: {
    apiKey: envConfig.etherscanApiKey,
  },
  gasReporter: {
    coinmarketcap: envConfig.coinmarketcapApiKey,
    currency: 'USD',
    enabled: envConfig.reportGas,
  },
};

export default config;
