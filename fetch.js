import { configDotenv } from "dotenv";
import { ethers } from "ethers";
configDotenv(); // Make sure this runs before accessing process.env
import { WrapperBuilder } from "@redstone-finance/evm-connector";

// Correct import for JSON ABI file using ESM
import oracleAbi from "./abi/redstone.json" assert { type: "json" };

// Ensure these environment variables are set in your .env file
const RPC_URL = process.env.RPC_URL;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
// Make sure this address matches where your Redstone.sol contract is deployed
const CONTRACT_ADDRESS ="0x5FbDB2315678afecb367f032d93F642f64180aa3"; // Default Hardhat node deployment address

async function main() {
  if (!RPC_URL || !PRIVATE_KEY) {
      console.error("❌ Error: Please define RPC_URL and PRIVATE_KEY in your .env file.");
      process.exit(1);
  }
   console.log('private key : ', PRIVATE_KEY)
  const provider = new ethers.JsonRpcProvider(RPC_URL);
  const wallet = new ethers.Wallet(PRIVATE_KEY, provider);

  console.log(`Attempting to interact with contract at: ${CONTRACT_ADDRESS}`);
  console.log(`Using wallet address: ${wallet.address}`);

  // ***** DEBUGGING STEP: Check the imported ABI *****
  console.log("Checking imported ABI structure...");
  console.log("Type of oracleAbi:", typeof oracleAbi);

  console.log("ABI seems valid, proceeding...");
  // ***** END DEBUGGING STEP *****



  try {
    // Create the original contract instance
    console.log('abi is :', oracleAbi)
  // This line requires oracleAbi.abi to be a valid ABI array
  const oracleConsumer = new ethers.Contract(CONTRACT_ADDRESS, oracleAbi, wallet);

  // Wrap the contract instance with RedStone Wrapper
  // This line requires oracleConsumer to be a valid ethers.Contract instance
  const wrappedContract = WrapperBuilder.wrap(oracleConsumer).usingDataService({
    dataFeeds: ["ETH"],
  });
    // Call the function on the wrappedContract
    const price = await wrappedContract.getTONPrice();
    console.log('returned price : ',price)
    // Note: Adjust decimals based on Redstone's price feed (usually 8)
    console.log("📈 ETH Price from RedStone:", ethers.formatUnits(price, 8));
  } catch (err) {
    console.error("❌ Error calling getETHPrice:", err);
    if (err.data) {
        console.error("Revert data:", err.data);
    }
    if (err.transaction) {
        console.error("Transaction:", err.transaction);
    }
 }
}

main().catch((err) => {
  console.error("❌ Unhandled Error in main function:", err);
  process.exit(1); // Exit with error code
});