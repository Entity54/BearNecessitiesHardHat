// npx hardhat run scripts/deploy_AxelarFantomSatelite.js
// or npx hardhat run --network <your-network> scripts/deploy_AxelarFantomSatelite.js

// npx hardhat run --network Fantom scripts/deploy_AxelarFantomSatelite.js


// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {

  const AxelarFantomSatelite = await hre.ethers.getContractFactory("AxelarFantomSatelite");

  //Mainnet 
  const axelarFantomSatelite = await AxelarFantomSatelite.deploy("0x304acf330bbE08d1e512eefaa92F6a57871fD895","0x2d5d7d31F671F86C782533cc367F14109a082712");


  console.log(
    `axelarFantomSatelite with deployed to ${axelarFantomSatelite.address}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});



// axelarFantomSatelite with deployed to 0x27d7222AD292d017C6eE1f0B8043Da7F4424F6a0