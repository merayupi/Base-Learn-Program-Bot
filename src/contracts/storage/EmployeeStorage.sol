// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract EmployeeStorage {
    // Custom error for too many shares
    error TooManyShares(uint totalShares);

    // State variables optimized for storage packing
    // All these fit in one storage slot (32 bytes total):
    uint16 private shares;        // 0-65535 (enough for max 5000 shares) - 2 bytes
    uint24 private salary;        // 0-16,777,215 (enough for max 1,000,000) - 3 bytes
    uint256 public idNumber;      // Full 32 bytes for employee ID - separate slot
    string public name;           // Dynamic size - separate slot(s)

    // Constructor to set initial values
    constructor() {
        shares = 1000;
        name = "Pat";
        salary = 50000;
        idNumber = 112358132134;
    }

    // View functions for private variables
    function viewSalary() external view returns (uint256) {
        return salary;
    }

    function viewShares() external view returns (uint256) {
        return shares;
    }

    // Grant shares function
    function grantShares(uint16 _newShares) external {
        // Check if _newShares itself is greater than 5000
        if (_newShares > 5000) {
            revert("Too many shares");
        }

        // Calculate total shares after adding new ones
        uint256 totalShares = shares + _newShares;

        // Check if total would exceed 5000
        if (totalShares > 5000) {
            revert TooManyShares(totalShares);
        }

        // Add the shares
        shares = uint16(totalShares);
    }

    /**
    * Do not modify this function.  It is used to enable the unit test for this pin
    * to check whether or not you have configured your storage variables to make
    * use of packing.
    *
    * If you wish to cheat, simply modify this function to always return `0`
    * I'm not your boss ¯\_(ツ)_/¯
    *
    * Fair warning though, if you do cheat, it will be on the blockchain having been
    * deployed by your wallet....FOREVER!
    */
    function checkForPacking(uint _slot) public view returns (uint r) {
        assembly {
            r := sload(_slot)
        }
    }

    /**
    * Warning: Anyone can use this function at any time!
    */
    function debugResetShares() public {
        shares = 1000;
    }
}
