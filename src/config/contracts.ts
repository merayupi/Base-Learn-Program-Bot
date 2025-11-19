// src/config/contracts.ts
import path from "path";
import type { Address } from "viem";

export interface DeployContext {
    deployed: Record<string, Address>;
}

export interface ContractConfig {
    id: string;
    artifactPath: string;
    getConstructorArgs?: (ctx: DeployContext) => unknown[];
}

const build = (file: string) =>
    path.join(process.cwd(), "src/contracts/build/src/contracts", file);

export const CONTRACTS: ContractConfig[] = [
    {
        id: "BasicMath",
        artifactPath: build("./basic-contract/BasicMath.sol/BasicMath.json"),
    },
    {
        id: "ControlStructures",
        artifactPath: build("./control-flow/ControlStructures.sol/ControlStructures.json"),
    },
    {
        id: "EmployeeStorage",
        artifactPath: build("./storage/EmployeeStorage.sol/EmployeeStorage.json"),
    },
    {
        id: "ArraysExercise",
        artifactPath: build("./arrays/ArraysExercise.sol/ArraysExercise.json"),
    },
    {
        id: "FavoriteRecords",
        artifactPath: build("./mappings/FavoriteRecords.sol/FavoriteRecords.json"),
    },

    // --- Inheritance-related ---
    {
        id: "SalesPerson",
        artifactPath: build("./inheritance/InheritanceExercise.sol/SalesPerson.json"),
        getConstructorArgs: () => [
            55555, // employeeNumber
            12345, // ManagerID
            20, // HourlyRate
        ],
    },
    {
        id: "EngineeringManager",
        artifactPath: build("./inheritance/InheritanceExercise.sol/EngineeringManager.json"),
        getConstructorArgs: () => [
            54321, // IDNumber
            11111, // ManagerID
            200000, // Annual Salary
        ],
    },
    {
        id: "InheritanceSubmission",
        artifactPath: build("./inheritance/InheritanceSubmission.sol/InheritanceSubmission.json"),
        getConstructorArgs: (ctx) => [
            ctx.deployed["SalesPerson"],
            ctx.deployed["EngineeringManager"],
        ],
    },

    {
        id: "GarageManager",
        artifactPath: build("./structs/GarageManager.sol/GarageManager.json"),
    },
    {
        id: "ImportsExercise",
        artifactPath: build("./imports/ImportsExercise.sol/ImportsExercise.json"),
    },
    {
        id: "ErrorTriageExercise",
        artifactPath: build("./debugging/ErrorTriageExercise.sol/ErrorTriageExercise.json"),
    },
    {
        id: "AddressBookFactory",
        artifactPath: build("./factory-pattern/AddressBookFactory.sol/AddressBookFactory.json"),
    },
    {
        id: "UnburnableToken",
        artifactPath: build("./simple-token/UnburnableToken.sol/UnburnableToken.json"),
    },
    {
        id: "WeightedVoting",
        artifactPath: build("./erc-20/WeightedVoting.sol/WeightedVoting.json"),
    },
    {
        id: "HaikuNFT",
        artifactPath: build("./erc-721/HaikuNFT.sol/HaikuNFT.json"),
    },
];
