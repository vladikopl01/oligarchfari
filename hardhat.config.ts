import '@nomiclabs/hardhat-waffle';
import '@nomiclabs/hardhat-ethers';
import '@nomiclabs/hardhat-etherscan';
import '@nomiclabs/hardhat-solhint';
import '@typechain/hardhat';
import '@typechain/ethers-v5';
import 'hardhat-gas-reporter';

import { HardhatUserConfig } from 'hardhat/types';
import { secretConfig, basicConfig } from './utils/config';

const config: HardhatUserConfig = {
  solidity: '0.8.11',
  networks: {
    hardhat: {},
    mainnet: {
      url: `https://mainnet.infura.io/v3/${secretConfig.infuraApiKey}`,
    },
    ropsten: {
      url: `https://ropsten.infura.io/v3/${secretConfig.infuraApiKey}`,
    },
  },
  typechain: {
    outDir: 'typechain',
    target: 'ethers-v5',
  },
  etherscan: {
    apiKey: secretConfig.etherscanApiKey,
  },
  gasReporter: {
    coinmarketcap: secretConfig.coinmarketcapApiKey,
    currency: 'USD',
    enabled: basicConfig.reportGas,
  },
};

export default config;
