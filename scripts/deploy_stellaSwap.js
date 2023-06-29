// npx hardhat run scripts/deploy_stellaSwap.js
// or npx hardhat run --network <your-network> scripts/deploy_stellaSwap.js

// npx hardhat run --network Moonbeam scripts/deploy_stellaSwap.js

// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {

  const StellaSwap = await hre.ethers.getContractFactory("StellaSwap");
  const stellaSwap = await StellaSwap.deploy();
  await stellaSwap.deployed();

  console.log(
    `stellaSwap with deployed to ${stellaSwap.address}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});



// MOONBEAM
// stellaSwap with deployed to 0xF7aC2a2AdEaA1EFc0Bd4130F5a28AE73A1225663