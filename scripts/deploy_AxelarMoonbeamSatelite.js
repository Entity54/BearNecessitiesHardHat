// npx hardhat run scripts/deploy_AxelarMoonbeamSatelite.js
// or npx hardhat run --network <your-network> scripts/deploy_AxelarMoonbeamSatelite.js
// npx hardhat run --network Moonbase scripts/deploy_AxelarMoonbeamSatelite.js

// npx hardhat run --network Moonbeam scripts/deploy_AxelarMoonbeamSatelite.js


// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {

  const AxelarMoonbeamSatelite = await hre.ethers.getContractFactory("AxelarMoonbeamSatelite");

  //Testnet
  // const axelarMoonbeamSatelite = await AxelarMoonbeamSatelite.deploy("0x5769D84DD62a6fD969856c75c7D321b84d455929","0xbE406F0189A0B4cf3A05C286473D23791Dd44Cc6","0x24aA375Ba88cC6751c2998fA24B007C48d0bA6a4");
  //Mainnet 
  const axelarMoonbeamSatelite = await AxelarMoonbeamSatelite.deploy("0x4F4495243837681061C4743b74B3eEdf548D56A5","0x2d5d7d31F671F86C782533cc367F14109a082712");
  await axelarMoonbeamSatelite.deployed();


  console.log(
    `axelarMoonbeamSatelite with deployed to ${axelarMoonbeamSatelite.address}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});



// axelarMoonbeamSatelite with deployed to 0xb85E1D77d6430bBDAF91845181440407c3c2bf6b