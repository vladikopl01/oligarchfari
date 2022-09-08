import hre from 'hardhat';
import { OligarchFari__factory } from '../typechain';
import { envConfig, supportChainIds } from '../utils/config';
import { getWalletByPrivateKey } from '../utils/utils';

async function deployOligarchFari(): Promise<void> {
  try {
    if (!envConfig.walletPrivateKey || !envConfig.infuraApiKey) {
      throw new Error(
        'Environment variables not specified!\n' +
          (!envConfig.walletPrivateKey ? '\tSpecify WALLET_PRIVATE_KEY!\n' : '') +
          (!envConfig.infuraApiKey ? '\tSpecify INFURA_API_KEY!\n' : ''),
      );
    }

    const network = await hre.ethers.provider.getNetwork();
    console.log(`Network chain id: ${network.chainId}`);

    const wallet =
      supportChainIds.indexOf(network.chainId) != -1
        ? getWalletByPrivateKey(envConfig.walletPrivateKey, hre.ethers.provider)
        : (await hre.ethers.getSigners())[0];
    console.log(`Wallet address: ${wallet.address}`);

    const contract = await new OligarchFari__factory(wallet).deploy();
    await contract.deployed();
    await contract.deployTransaction.wait(5);

    console.log(`Deployed to address: ${contract.address}`);

    if (supportChainIds.indexOf(network.chainId) != -1) {
      console.log('Verifying...');
      try {
        await hre.run('verify', {
          address: contract.address,
          contract: 'contracts/OligarchFari.sol:OligarchFari',
          constructorArguments: [],
        });
      } catch (err) {
        console.log(err);
      }
    }

    console.log('Done!');
  } catch (err) {
    console.log(err);
  }
}

async function main() {
  await deployOligarchFari();
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
