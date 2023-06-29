Source: https://hardhat.org/hardhat-runner/docs/getting-started

    $npm init
    $npm install --save-dev hardhat //could ask for sudo
    $npx hardhat

    👷 Welcome to Hardhat v2.14.0 👷‍

    ✔ What do you want to do? · Create a JavaScript project
    ✔ Hardhat project root: · /Users/ad/Desktop/HardHat-BoilerPlate
    ✔ Do you want to add a .gitignore? (Y/n) · y
    ✔ Do you want to install this sample project's dependencies with npm (@nomicfoundation/hardhat-toolbox)? (Y/n) · y

Install the below also

    $sudo npm install --save-dev @nomicfoundation/hardhat-toolbox@^2.0.0

# NOTE

The above are the instructions for startign from scratch

If you download this repo the probably a

    $npm install

will be enough to run with the rest of the commands

> Note: For testing change the network to:

    defaultNetwork: "hardhat",

<br>

## COMPILE

    $npx hardhat compile

ad@192 HardHat-BoilerPlate % npx hardhat compile  
Downloading compiler 0.8.18
Compiled 1 Solidity file successfully

> Compiles all you smart contracts

> After the initial compilation, Hardhat will try to do the least amount of work possible the next time you compile. For example, if you didn't change any files since the last compilation, nothing will be compiled:

    $ npx hardhat compile
    Nothing to compile

If you only modified one file, only that file and others affected by it will be recompiled.

Look at ./artifacts

## CLEAN and FORCE

To force a compilation you can use the

--force argument,

    npx hardhat compile --force

or run

    npx hardhat clean //to clear the cache and delete the artifacts.

<br>
<br>
<br>

## TESTS

You can run your tests with

    $npx hardhat test:

## DEPLOY

Next, to deploy the contract we will use a Hardhat script.

Inside the scripts/ folder you will find a file with the following code:

    // We require the Hardhat Runtime Environment explicitly here. This is optional
    // but useful for running the script in a standalone fashion through `node <script>`.
    //
    // You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
    // will compile your contracts, add the Hardhat Runtime Environment's members to the
    // global scope, and execute the script.
    const hre = require("hardhat");

    async function main() {
        const currentTimestampInSeconds = Math.round(Date.now() / 1000);
        const unlockTime = currentTimestampInSeconds + 60;

        const lockedAmount = hre.ethers.utils.parseEther("0.001");

        const Lock = await hre.ethers.getContractFactory("Lock");
        const lock = await Lock.deploy(unlockTime, { value: lockedAmount });

        await lock.deployed();

        console.log(
            `Lock with ${ethers.utils.formatEther(
            lockedAmount
            )}ETH and unlock timestamp ${unlockTime} deployed to ${lock.address}`
        );
    }

    // We recommend this pattern to be able to use async/await everywhere
    // and properly handle errors.
    main().catch((error) => {
        console.error(error);
        process.exitCode = 1;
    });

You can run it using npx hardhat run

    $ npx hardhat run scripts/deploy.js

    Lock with 1 ETH deployed to: 0x5FbDB2315678afecb367f032d93F642f64180aa3

You can deploy in the localhost network following these steps:

1. Start a local node

   npx hardhat node

2. Open a new terminal and deploy the smart contract in the localhost network

   npx hardhat run --network localhost scripts/deploy.js

<br>

## As general rule, you can target any network from your Hardhat config using:

    npx hardhat run --network <your-network> scripts/deploy.js

<br>
<br>
<br>

## CONFIGURATION

When Hardhat is run, it searches for the closest hardhat.config.js file starting from the Current Working Directory. This file normally lives in the root of your project. An empty hardhat.config.js is enough for Hardhat to work.

The entirety of your Hardhat setup (i.e. your config, plugins and custom tasks) is contained in this file.

## Available config options

To set up your config, you have to export an object from hardhat.config.js

This object can have entries like defaultNetwork, networks, solidity, paths and mocha
For example:

    module.exports = {
    defaultNetwork: "sepolia",
    networks: {
        hardhat: {
        },
        sepolia: {
        url: "https://sepolia.infura.io/v3/<key>",
        accounts: [privateKey1, privateKey2, ...]
        }
    },
    solidity: {
        version: "0.5.15",
        settings: {
        optimizer: {
            enabled: true,
            runs: 200
        }
        }
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

You can customize which network is used by default when running Hardhat by setting the config's defaultNetwork field. If you omit this config, its default value is "hardhat".

Hardhat Network
Hardhat comes built-in with a special network called hardhat. When using this network, an instance of the Hardhat Network will be automatically created when you run a task, script or test your smart contracts.

Hardhat Network has first-class support of Solidity. It always knows which smart contracts are being run and exactly what they do and why they fail.

Example for Moonbase Alpha set as default

ad@192 HardHat-BoilerPlate % npx hardhat run scripts/deploy.js
Lock with 0.001ETH and unlock timestamp 1683399297 deployed to 0x8e276766C0e4909421fF898DF085ac3a1b6438C9

<br>
<br>

## External networks

If you need to use an external network, like an Ethereum testnet, mainnet or some other specific node software, you can set it up using the networks configuration entries in the exported object in hardhat.config.js, which is how Hardhat projects manage settings.

You can make use of the --network CLI parameter to quickly change the network.

<br>
<br>

## Tasks and Scripts

Source: https://hardhat.org/hardhat-runner/docs/guides/tasks-and-scripts and https://hardhat.org/hardhat-runner/docs/advanced/scripts and https://hardhat.org/hardhat-runner/docs/advanced/create-task

HardHat exposes the HardHat Runtime Environment (https://hardhat.org/hardhat-runner/docs/advanced/hardhat-runtime-environment) which mimics a chain

This offers globally to all your scripts and tasks a ton of things you would expect in an EVM e.g. ethers library

1. Tasks behave like javascript scripts but allow you to pass arguments from cli and automate certain procedures

Write your taks in hardhat.config.js

Example:

    require("@nomicfoundation/hardhat-toolbox");

    //$npx hardhat accounts
    task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
    const accounts = await hre.ethers.getSigners();

    for (const account of accounts) {
        console.log(account.address);
    }
    });

More example can be found int eh above links e.g. how to pass arguments that can be read in taskArgs.

Tasks are very handy but it feels as if it is more apporpriate for short scripts

2. Scripts behave like usual JS scripts and can be run as

   $npx hardhat run scripts/accounts.js

Here we still have access to the Hardhat runtime environment but we can write a whole script automating a ton of things

Example:

    // $npx hardhat run scripts/accounts.js

    async function main() {
        const accounts = await ethers.getSigners();

        for (const account of accounts) {
        console.log(account.address);
        }
    }

    main().catch((error) => {
        console.error(error);
        process.exitCode = 1;
    });

> Scripts offer you a quick way to mimic front end behaviour, i.e. connect to smart contract and do stuff with it
