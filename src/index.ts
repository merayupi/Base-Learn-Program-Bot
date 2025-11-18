import "dotenv/config";
import { deployAllContracts } from "./core/deployer";
import { submitAllToTesters } from "./core/submitter";
import { compileHardhat } from "./core/compiler";

async function main() {
    console.log("Starting full pipeline: DEPLOY ➜ SUBMIT\n");

    try {
        // First, compile the contracts
        compileHardhat();
        // === 2. DEPLOY ALL ===
        console.log("Step 2: Deploying all contracts...\n");
        const deployed = await deployAllContracts();

        console.log("\nDeploy completed!");
        console.log("Deployed addresses:", deployed);

        // === 3. SUBMIT TO TESTERS ===
        console.log("\nStep 3: Submitting to CA testers...\n");
        await submitAllToTesters();

        console.log("\nAll done! All exercises deployed and submitted.");
    } catch (err) {
        console.error("\nERROR:", err);
        process.exit(1);
    }
}

main();
