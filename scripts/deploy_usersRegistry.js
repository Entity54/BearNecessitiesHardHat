// npx hardhat run scripts/deploy_usersRegistry.js
// or npx hardhat run --network <your-network> scripts/deploy_usersRegistry.js
// npx hardhat run --network Moonbase scripts/deploy_usersRegistry.js

// npx hardhat run --network Moonbeam scripts/deploy_usersRegistry.js


// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {

  const UsersRegistry = await hre.ethers.getContractFactory("UsersRegistry");
  const usersRegistry = await UsersRegistry.deploy();
  await usersRegistry.deployed();

  console.log(
    `usersRegistry with deployed to ${usersRegistry.address}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});


// usersRegistry with deployed to 0x70388FDc83f5D1f69Dd6595112366C0e578CcEe5

//MOONBEAM
// usersRegistry with deployed to 0xC11029E655456618bC9FaDFF92B52D99863A9A55