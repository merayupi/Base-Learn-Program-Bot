# Base Learn Program Bot

Deploys all exercises to Base Sepolia and submits each deployed address to its tester contract.

## What It Does
- Compiles Solidity via Hardhat.
- Deploys contracts in order from `src/config/contracts.ts` using viem.
- Saves deployed addresses to `src/deployments/base-sepolia.json`.
- Calls `testContract(address)` on each tester in `src/config/exerciseTesters.ts`.

## Requirements
- Node.js 18+
- pnpm or npm
- Some Base Sepolia ETH for gas

## Install
```bash
pnpm install
```
or
```bash
npm install
```

## Configure
Create a `.env` in the project root with your test private key (hex with `0x`):
```env
PRIVATE_KEY=0xabc123...yourprivatekey
```
Notes:
- Use a throwaway/test account only.
- Keep your key secret; do not commit `.env`.

## Run
```bash
pnpm start
```
or
```bash
npm start
```
The script will:
- Run `npx hardhat compile --force`.
- Deploy all artifacts found under `src/contracts/build/src/contracts/**/Contract.json`.
- Write results to `src/deployments/base-sepolia.json`.
- Submit each address to its tester contract.

Main outputs:
- `src/deployments/base-sepolia.json`: map of `{ id: address }`.
- Console logs with transaction hashes and deployed addresses.

## Project Structure
- `src/index.ts`: pipeline entry (compile → deploy → submit).
- `src/core/compiler.ts`: runs Hardhat compile.
- `src/core/deployer.ts`: deploys and writes `src/deployments/base-sepolia.json`.
- `src/core/submitter.ts`: submits addresses to testers.
- `src/core/client.ts`: viem client + account from `.env`.
- `src/config/contracts.ts`: list of contracts and constructor args.
- `src/config/exerciseTesters.ts`: tester ABI and addresses (Base Sepolia).
- `src/contracts/build/...`: Hardhat artifacts (ABI + bytecode JSON).

## Customize
- Change deploy order or add/remove contracts in `src/config/contracts.ts`.
- Update tester addresses in `src/config/exerciseTesters.ts`.

## Troubleshooting
- `PRIVATE_KEY belum di-set di .env`: create `.env` and set `PRIVATE_KEY`.
- `insufficient funds for gas`: fund your Base Sepolia account.
- Invalid artifact: ensure ABI/bytecode exist in `src/contracts/build` (run compile).
