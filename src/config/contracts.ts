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
    path.join(process.cwd(), "src/contracts/build", file);

export const CONTRACTS: ContractConfig[] = [
    {
        id: "BasicMath",
        artifactPath: build("BasicMath.json"),
    },
    {
        id: "ControlStructures",
        artifactPath: build("ControlStructures.json"),
    },
    {
        id: "EmployeeStorage",
        artifactPath: build("EmployeeStorage.json"),
    },
    {
        id: "ArraysExercise",
        artifactPath: build("ArraysExercise.json"),
    },
    {
        id: "FavoriteRecords",
        artifactPath: build("FavoriteRecords.json"),
    },

    // --- Inheritance-related ---
    {
        id: "SalesPerson",
        artifactPath: build("SalesPerson.json"),
        getConstructorArgs: () => [
            55555, // employeeNumber
            12345, // officeNumber
            20, // salesTarget
        ],
    },
    {
        id: "EngineeringManager",
        artifactPath: build("EngineeringManager.json"),
        getConstructorArgs: () => [
            33333, // employeeNumber
            54321, // officeNumber
            5, // teamCount
        ],
    },
    {
        id: "InheritanceSubmission",
        artifactPath: build("InheritanceSubmission.json"),
        getConstructorArgs: (ctx) => [
            ctx.deployed["SalesPerson"],
            ctx.deployed["EngineeringManager"],
        ],
    },

    {
        id: "GarageManager",
        artifactPath: build("GarageManager.json"),
    },
    {
        id: "ImportsExercise",
        artifactPath: build("ImportsExercise.json"),
    },
    {
        id: "ErrorTriageExercise",
        artifactPath: build("ErrorTriageExercise.json"),
    },
    {
        id: "AddressBookFactory",
        artifactPath: build("AddressBookFactory.json"),
    },
    {
        id: "UnburnableToken",
        artifactPath: build("UnburnableToken.json"),
    },
    {
        id: "WeightedVoting",
        artifactPath: build("WeightedVoting.json"),
    },
    {
        id: "HaikuNFT",
        artifactPath: build("HaikuNFT.json"),
    },
];
