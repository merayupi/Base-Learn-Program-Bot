# Base Learn Program Bot

This bot runs a deploy and submit to test contract.
It deploys all contracts to Base Sepolia, then submits to tester contracts.

## Summary
- Deploy all contracts from `src/contracts/build`.
- Save addresses to `deployments/base-sepolia.json`.
- Submit addresses to testers in `src/config/exerciseTesters.ts`.

## Prerequisites
- Node.js 18 or newer.
- pnpm or npm installed.
- ETH on Base Sepolia for gas.

## Installation
```
pnpm install
```
or
```
npm install
```

## Configuration
Create a `.env` file in the project root.
Add your private key in hex format with `0x` prefix.

Example `.env`:
```
PRIVATE_KEY=0xabc123...yourprivatekey
```

Use a test account.
Do not share your private key.

## Run
```
pnpm start
```
or
```
npm start
```
What it does:
- Deploys contracts in the order from `src/config/contracts.ts`.
- Writes results to `deployments/base-sepolia.json`.
- Calls `testContract` on each tester contract.

Main outputs:
- File `deployments/base-sepolia.json` with `id` and `address` pairs.
- Logs with transaction hashes and contract addresses.

## Project Structure
- `src/index.ts`: entry point. Runs deploy and submit.
- `src/core/deployer.ts`: deploy logic and address saving.
- `src/core/submitter.ts`: submit addresses to testers.
- `src/core/client.ts`: viem clients and account setup.
- `src/config/contracts.ts`: contract list and constructor args.
- `src/config/exerciseTesters.ts`: tester ABI and tester addresses.
- `src/contracts/build/*.json`: ABI and bytecode artifacts.
- `deployments/base-sepolia.json`: deploy result file.

## Customize
- Edit the contract list in `src/config/contracts.ts`.
- Edit tester addresses in `src/config/exerciseTesters.ts`.

## Troubleshooting
- `PRIVATE_KEY belum di-set di .env`: create `.env`, set `PRIVATE_KEY`.
- `insufficient funds for gas`: fund your Base Sepolia account.
- Invalid artifact: check ABI and bytecode in `src/contracts/build`.
- RPC error: retry, check connection and network.
