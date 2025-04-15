import hre from 'hardhat'

async function main() {
  const OracleConsumer = await hre.ethers.getContractFactory("Redstone");
  const oracleConsumer = await OracleConsumer.deploy();
    await oracleConsumer.waitForDeployment();
    // --- Get the address (Recommended way for ethers v6+) ---
  const contractAddress = await oracleConsumer.getAddress();
  console.log("redstone deployed to:", contractAddress);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

//0x5FbDB2315678afecb367f032d93F642f64180aa3