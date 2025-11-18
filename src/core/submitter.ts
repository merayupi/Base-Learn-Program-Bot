import fs from "fs/promises";
import path from "path";
import type { Address } from "viem";
import { createClients } from "./client";
import { EXERCISE_TESTERS, TEST_CONTRACT_ABI } from "../config/exerciseTesters";

export async function submitAllToTesters() {
    const { publicClient, walletClient } = createClients();

    const filePath = path.join(process.cwd(), "deployments", "base-sepolia.json");
    const raw = await fs.readFile(filePath, "utf-8");
    const deployed = JSON.parse(raw) as Record<string, string>;

    console.log("Loaded deployed addresses:", deployed);

    for (const [id, addr] of Object.entries(deployed)) {
        const tester = EXERCISE_TESTERS[id];
        if (!tester) {
            console.log(`(skip) No tester CA configured for ${id}`);
            continue;
        }

        console.log(`\n=== Submitting ${id} to tester ${tester} ===`);
        console.log(`Contract address: ${addr}`);

        const hash = await walletClient.writeContract({
            address: tester as Address,
            abi: TEST_CONTRACT_ABI,
            functionName: "testContract",
            args: [addr as Address],
        });

        console.log("testContract tx hash:", hash);
        await publicClient.waitForTransactionReceipt({ hash });
        console.log(`✅ ${id} submission confirmed`);
    }
}
