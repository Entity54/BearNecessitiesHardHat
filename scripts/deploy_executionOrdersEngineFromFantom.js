// npx hardhat run scripts/deploy_executionOrdersEngineFromFantom.js
// or npx hardhat run --network <your-network> scripts/deploy_executionOrdersEngineFromFantom.js
// npx hardhat run --network Moonbase scripts/deploy_executionOrdersEngineFromFantom.js

// npx hardhat run --network Moonbeam scripts/deploy_executionOrdersEngineFromFantom.js


// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {

  const ExecutionOrdersEngineFromFantom = await hre.ethers.getContractFactory("ExecutionOrdersEngineFromFantom");

  //Mainnet 
  const executionOrdersEngineFromFantom = await ExecutionOrdersEngineFromFantom.deploy("0x4F4495243837681061C4743b74B3eEdf548D56A5","0x2d5d7d31F671F86C782533cc367F14109a082712");
  await executionOrdersEngineFromFantom.deployed();


  console.log(
    `executionOrdersEngineFromFantom with deployed to ${executionOrdersEngineFromFantom.address}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});


// executionOrdersEngineFromFantom with deployed to 0xc259A95E717ccf5aEDA5971CE967E528Fa624Bc4