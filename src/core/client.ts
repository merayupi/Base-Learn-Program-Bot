// src/core/client.ts
import {
  createPublicClient,
  createWalletClient,
  http,
  type PublicClient,
  type WalletClient,
  type Transport,
} from "viem";
import { privateKeyToAccount } from "viem/accounts";
import { baseSepolia } from "viem/chains";
import dotenv from "dotenv";

dotenv.config();

export interface Clients {
  publicClient: PublicClient<Transport, typeof baseSepolia>;
  walletClient: WalletClient<Transport, typeof baseSepolia, ReturnType<typeof privateKeyToAccount>>;
}

export function createClients(): Clients {
  if (!process.env.PRIVATE_KEY) {
    throw new Error("PRIVATE_KEY belum di-set di .env");
  }

  const account = privateKeyToAccount(process.env.PRIVATE_KEY as `0x${string}`);

  const publicClient = createPublicClient({
    chain: baseSepolia,
    transport: http(),
  });

  const walletClient = createWalletClient({
    chain: baseSepolia,
    transport: http(),
    account,
  });

  console.log("Deployer address:", account.address);

  return {
    publicClient: publicClient as PublicClient<Transport, typeof baseSepolia>,
    walletClient: walletClient as WalletClient<Transport, typeof baseSepolia, typeof account>,
  };
}
