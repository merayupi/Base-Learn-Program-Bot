// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract UnburnableToken {
    // Custom errors
    error TokensClaimed();
    error AllTokensClaimed();
    error UnsafeTransfer(address);
    
    // Public storage variables
    mapping(address => uint256) public balances;
    uint256 public totalSupply;
    uint256 public totalClaimed;
    
    // Track which addresses have claimed tokens
    mapping(address => bool) private hasClaimed;
    
    constructor() {
        totalSupply = 100000000; // 100 million tokens
        totalClaimed = 0;
    }
    
    // Claim function - 1000 tokens per address, only once
    function claim() public {
        // Check if this address has already claimed
        if (hasClaimed[msg.sender]) {
            revert TokensClaimed();
        }
        
        uint256 claimAmount = 1000;
        
        // Check if all tokens have been claimed
        if (totalClaimed + claimAmount > totalSupply) {
            revert AllTokensClaimed();
        }
        
        // Mark as claimed and transfer tokens
        hasClaimed[msg.sender] = true;
        balances[msg.sender] += claimAmount;
        totalClaimed += claimAmount;
    }
    
    // Safe transfer function with safety checks
    function safeTransfer(address _to, uint256 _amount) public {
        // Check if sender has enough tokens first
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        
        // Check if recipient is not zero address
        if (_to == address(0)) {
            revert UnsafeTransfer(_to);
        }
        
        // Check if recipient has a balance greater than zero ETH
        if (_to.balance == 0) {
            revert UnsafeTransfer(_to);
        }
        
        // Perform the transfer
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
    }
}
