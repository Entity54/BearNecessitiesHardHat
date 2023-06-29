// npx hardhat run scripts/deploy_executionOrdersEngineMoonbeam.js
// or npx hardhat run --network <your-network> scripts/deploy_executionOrdersEngineMoonbeam.js
// npx hardhat run --network Moonbase scripts/deploy_executionOrdersEngineMoonbeam.js

// npx hardhat run --network Moonbeam scripts/deploy_executionOrdersEngineMoonbeam.js


// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {

  const ExecutionOrdersEngineMoonbeam = await hre.ethers.getContractFactory("ExecutionOrdersEngineMoonbeam");
  const executionOrdersEngineMoonbeam = await ExecutionOrdersEngineMoonbeam.deploy();
  await executionOrdersEngineMoonbeam.deployed();

  console.log(
    `executionOrdersEngineMoonbeam with deployed to ${executionOrdersEngineMoonbeam.address}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});


// executionOrdersEngineMoonbeam with deployed to 0x05c8ff63cC0dd09B3043b055f5B21B6D5E2Ed588

//MOONBEAM
// executionOrdersEngineMoonbeam with deployed to 0xbe7eEB5c4fcbB2B617AAd30bdd4ee44Fe91Fd397
// executionOrdersEngineMoonbeam with deployed to 0xce47EE729055A6EF5CCe58B2a319ed8035B90Dcf