import "dotenv/config";
import { deployAllContracts } from "./core/deployer";
import { submitAllToTesters } from "./core/submitter";

async function main() {
  console.log("Starting full pipeline: DEPLOY ➜ SUBMIT\n");

  try {
    // === 1. DEPLOY ALL ===
    console.log("Step 1: Deploying all contracts...\n");
    const deployed = await deployAllContracts();

    console.log("\nDeploy completed!");
    console.log("Deployed addresses:", deployed);

    // === 2. SUBMIT TO TESTERS ===
    console.log("\nStep 2: Submitting to CA testers...\n");
    await submitAllToTesters();

    console.log("\nAll done! All exercises deployed and submitted.");
  } catch (err) {
    console.error("\nERROR:", err);
    process.exit(1);
  }
}

main();
