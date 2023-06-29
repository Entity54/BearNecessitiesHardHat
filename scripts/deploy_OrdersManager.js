// npx hardhat run scripts/deploy_OrdersManager.js
// or npx hardhat run --network <your-network> scripts/deploy_OrdersManager.js
// npx hardhat run --network Moonbase scripts/deploy_OrdersManager.js

// npx hardhat run --network Moonbeam scripts/deploy_OrdersManager.js


// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {

  const OrdersManager = await hre.ethers.getContractFactory("OrdersManager");
  const ordersManager = await OrdersManager.deploy();
  await ordersManager.deployed();

  console.log(
    `ordersManager with deployed to ${ordersManager.address}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});


//MOONBEAM
// ordersManager with deployed to 0xAdDf0567b0f24c77Bee1d070154a1A8417fE6Fc5
// ordersManager with deployed to 0x9331d7e0F7deD78a21d6A3d381cdc95Da689AF79

// ordersManager with deployed to 0x3357e0d9d3eF81Bc6b158313416de8879F2EDcF6