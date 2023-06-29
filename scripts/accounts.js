// npx hardhat run scripts/accounts.js
// npx hardhat run --network Moonbase scripts/accounts.js


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
