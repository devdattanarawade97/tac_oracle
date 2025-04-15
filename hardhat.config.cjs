// Load Hardhat plugins
require("@nomicfoundation/hardhat-toolbox");
require("hardhat-deploy");
require("hardhat-contract-sizer");

// Load environment variables
const dotenv = require("dotenv");
dotenv.config();

// Get private key or mnemonic from environment
const MNEMONIC = process.env.MNEMONIC;
const PRIVATE_KEY = process.env.PRIVATE_KEY;

const accounts = MNEMONIC
  ? { mnemonic: MNEMONIC }
  : PRIVATE_KEY
  ? [PRIVATE_KEY]
  : undefined;

if (accounts == null) {
  console.warn(
    "⚠️  Could not find MNEMONIC or PRIVATE_KEY in environment variables. Transactions will not be possible."
  );
}

// Export Hardhat config
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  paths: {
    cache: "cache/hardhat",
  },
  solidity: {
    compilers: [
      {
        version: "0.8.17",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
    ],
  },
  networks: {
    hardhat: {
      allowUnlimitedContractSize: true,
    },
    "tac-testnet": {
      url: "https://turin.rpc.tac.build",
      chainId: 2390,
      accounts,
    },
  },
  namedAccounts: {
    deployer: {
      default: 0,
    },
  },
};

//0x5FbDB2315678afecb367f032d93F642f64180aa3