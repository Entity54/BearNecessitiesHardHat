require("@nomicfoundation/hardhat-toolbox");
require('dotenv').config();

//$ npx hardhat accounts
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// /** @type import('hardhat/config').HardhatUserConfig */
// module.exports = {
//   solidity: "0.8.18",
// };
// "ethereum-2" is Ethereum Goerli
 
module.exports = {
  solidity: "0.8.18",
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
    },
    sepolia: {
      url: `https://sepolia.infura.io/v3/${process.env.INFURA_API_KEY}`,
      accounts: [process.env.ACCOUNT_1_PRIVATE_KEY, process.env.ACCOUNT_2_PRIVATE_KEY],
      chainId: 11155111,
      timeout: 60000,
    },
    goerli: {
      url: `https://goerli.infura.io/v3/${process.env.INFURA_API_KEY}`,
      accounts: [process.env.ACCOUNT_1_PRIVATE_KEY, process.env.ACCOUNT_2_PRIVATE_KEY],
      chainId: 5,
      timeout: 60000,
    },
    "Smart Chain - Testnet": {
      url: "https://data-seed-prebsc-1-s1.binance.org:8545/",
      accounts: [process.env.ACCOUNT_1_PRIVATE_KEY, process.env.ACCOUNT_2_PRIVATE_KEY],
      chainId: 97,
      timeout: 60000,
    },
    "Moonbase": {
      url: "https://rpc.api.moonbase.moonbeam.network",
      accounts: [process.env.ACCOUNT_1_PRIVATE_KEY, process.env.ACCOUNT_2_PRIVATE_KEY],
      chainId: 1287,
      timeout: 60000,
    },
    "base": {
      url: "https://sepolia.infura.io/v3/<key>",
      accounts: [process.env.ACCOUNT_1_PRIVATE_KEY, process.env.ACCOUNT_2_PRIVATE_KEY],
      chainId: 84531,
      timeout: 60000,
    },
    "Fantom-testnet": {
      url: "https://sepolia.infura.io/v3/<key>",
      accounts: [process.env.ACCOUNT_FANTOM_PRIVATE_KEY, process.env.ACCOUNT_2_PRIVATE_KEY],
      chainId: 4002,
      timeout: 60000,
    },
    "Shibuya Network": {
      url: "https://rpc.shibuya.astar.network:8545",
      accounts: [process.env.ACCOUNT_1_PRIVATE_KEY, process.env.ACCOUNT_2_PRIVATE_KEY],
      chainId: 81,
      timeout: 60000,
    },
    Ethereum: {
      url: "https://mainnet.infura.io/v3/",
      accounts: [process.env.ACCOUNT_1_PRIVATE_KEY, process.env.ACCOUNT_2_PRIVATE_KEY],
      chainId: 1,
      timeout: 60000,
    },
    binance: {
      url: "https://bsc-dataseed.binance.org/",
      accounts: [process.env.ACCOUNT_1_PRIVATE_KEY, process.env.ACCOUNT_2_PRIVATE_KEY],
      chainId: 56,
      timeout: 60000,
    },
    Moonbeam: {
      url: "https://rpc.api.moonbeam.network",
      accounts: [process.env.ACCOUNT_1_PRIVATE_KEY, process.env.ACCOUNT_2_PRIVATE_KEY],
      chainId: 1284,
      timeout: 60000,
    },
    Fantom: {
      url: "https://rpc.ftm.tools/",
      accounts: [process.env.ACCOUNT_FANTOM_PRIVATE_KEY, process.env.ACCOUNT_2_PRIVATE_KEY],
      chainId: 250,
      timeout: 60000,
    },
    "Polygon Mumbnai": {
      url: "https://matic-mumbai.chainstacklabs.com",
      accounts: [process.env.ACCOUNT_1_PRIVATE_KEY, process.env.ACCOUNT_2_PRIVATE_KEY],
      chainId: 80001,
      timeout: 60000,
    },
  },
  //FOR CONTRACT VERIFICATION
  etherscan: {
    url: "https://sepolia.etherscan.io",
    apiKey: "6TBUHYIZH8QXS71YW5XWMCWGVQIRRM2C6U",
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts"
  },
  mocha: {
    timeout: 40000
  }
}