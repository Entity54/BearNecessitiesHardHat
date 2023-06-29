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

## As general rule, you can target any network from your Hardhat config using:

    npx hardhat run --network <your-network> scripts/deploy.js

<br>

## .env

Please make sure you create a .env file at route and create
ACCOUNT_1_PRIVATE_KEY=<PRIVATE KEY>
ACCOUNT_2_PRIVATE_KEY=<PRIVATE KEY>
ACCOUNT_FANTOM_PRIVATE_KEY=<PRIVATE KEY>
