import fs from "fs/promises";
import path from "path";
import type { Address } from "viem";
import { createClients } from "./client";
import { CONTRACTS, type DeployContext, type ContractConfig } from "../config/contracts";

interface Artifact {
    abi: any[];
    bytecode: `0x${string}` | string;
}

export async function deployAllContracts() {
    const { publicClient, walletClient } = createClients();

    const ctx: DeployContext = { deployed: {} as Record<string, Address> };

    console.log("Starting deployment of contracts...");

    for (const cfg of CONTRACTS) {
        console.log(`Deploying contract: ${cfg.id}`);
        const artifact = await loadArtifact(cfg);

        const args = cfg.getConstructorArgs?.(ctx) ?? [];
        if (args.length) {
            console.log("Constructor args:", args);
        }

        const hash = await walletClient.deployContract({
            abi: artifact.abi,
            bytecode: artifact.bytecode as `0x${string}`,
            args,
        });

        console.log("Tx hash: https://sepolia.basescan.org/tx/", hash);

        const receipt = await publicClient.waitForTransactionReceipt({ hash });
        const address = receipt.contractAddress as Address;

        if (!address) {
            throw new Error(`Contract address null untuk ${cfg.id}`);
        }

        console.log(`${cfg.id} deployed at: ${address}`);
        ctx.deployed[cfg.id] = address;
    }

    const outDir = path.join(process.cwd(), "deployments");
    await fs.mkdir(outDir, { recursive: true });

    const outPath = path.join(outDir, "base-sepolia.json");
    await fs.writeFile(outPath, JSON.stringify(ctx.deployed, null, 2), "utf-8");

    console.log("\nSaved deployed addresses to:", outPath);

    return ctx.deployed;
}

async function loadArtifact(cfg: ContractConfig): Promise<Artifact> {
    const raw = await fs.readFile(cfg.artifactPath, "utf-8");
    const json = JSON.parse(raw);

    const abi = json.abi ?? json.ABI ?? json.contract?.abi;

    let bytecode: string | undefined;

    if (typeof json.bytecode === "string") {
        bytecode = json.bytecode;
    }

    else if (json.bytecode && typeof json.bytecode.object === "string") {
        bytecode = json.bytecode.object;
    }

    else if (json.evm?.bytecode?.object && typeof json.evm.bytecode.object === "string") {
        bytecode = json.evm.bytecode.object;
    }

    if (!abi || !bytecode) {
        console.error("Artifact JSON (debug):", {
            hasAbi: !!abi,
            bytecodeType: typeof json.bytecode,
        });
        throw new Error(`Artifact ${cfg.artifactPath} tidak punya abi/bytecode yang valid`);
    }

    return { abi, bytecode };
}
