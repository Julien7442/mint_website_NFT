// Import the hardhat library
const hre = require('hardhat');

// This is the main function that will be called when the script is run
async function main() {
  // Get the contract factory for the RoboPunksNFT contract
  const RoboPunksNFT = await hre.ethers.getContractFactory('RoboPunksNFT');

  // Deploy a new instance of the contract
  const roboPunksNFT = await RoboPunksNFT.deploy();

  // Wait for the contract to be deployed
  await roboPunksNFT.deployed();

  // Log the contract's address to the console
  console.log('RoboPunksNFT deployed to:', roboPunksNFT.address);
}

// Call the main function and handle any errors that may occur
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
