import { execSync } from "child_process";

export function compileHardhat() {
  console.log("⛏️ Running hardhat compile...");
  execSync("npx hardhat compile --force", { stdio: "inherit" });
  console.log("🎉 Compile done!");
}
