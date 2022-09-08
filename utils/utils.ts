import { providers, Wallet } from 'ethers';

export function getWalletByPrivateKey(privateKey: string, provider: providers.Provider): Wallet {
  try {
    return new Wallet(privateKey, provider);
  } catch (error) {
    throw new Error(`Invalid privateKey: ${privateKey}`);
  }
}
