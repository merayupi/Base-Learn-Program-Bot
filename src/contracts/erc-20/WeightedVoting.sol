// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

contract WeightedVoting is ERC20 {
    using EnumerableSet for EnumerableSet.AddressSet;
    
    uint256 public maxSupply = 1000000;
    
    // Custom errors
    error TokensClaimed();
    error AllTokensClaimed();
    error NoTokensHeld();
    error QuorumTooHigh(uint256 quorum);
    error AlreadyVoted();
    error VotingClosed();
    
    // Vote enum
    enum Vote {
        AGAINST,
        FOR,
        ABSTAIN
    }
    
    // Issue struct
    struct Issue {
        EnumerableSet.AddressSet voters;
        string issueDesc;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 votesAbstain;
        uint256 totalVotes;
        uint256 quorum;
        bool passed;
        bool closed;
    }
    
    // Return struct for getIssue (without EnumerableSet)
    struct ReturnableIssue {
        address[] voters;
        string issueDesc;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 votesAbstain;
        uint256 totalVotes;
        uint256 quorum;
        bool passed;
        bool closed;
    }
    
    // Storage - changed to private since it can't be public with EnumerableSet
    Issue[] private issues;
    mapping(address => bool) public hasClaimed;
    
    constructor() ERC20("WeightedVoting", "WV") {
        // Burn the zeroeth element of issues
        issues.push();
        issues[0].closed = true;
    }
    
    // Claim 100 tokens once per address
    function claim() public {
        if (hasClaimed[msg.sender]) {
            revert TokensClaimed();
        }
        
        if (totalSupply() + 100 > maxSupply) {
            revert AllTokensClaimed();
        }
        
        hasClaimed[msg.sender] = true;
        _mint(msg.sender, 100);
    }
    
    // Create a new issue
    function createIssue(string memory _issueDesc, uint256 _quorum) external returns (uint256) {
        if (balanceOf(msg.sender) == 0) {
            revert NoTokensHeld();
        }
        
        if (_quorum > totalSupply()) {
            revert QuorumTooHigh(_quorum);
        }
        
        issues.push();
        uint256 issueId = issues.length - 1;
        
        issues[issueId].issueDesc = _issueDesc;
        issues[issueId].quorum = _quorum;
        issues[issueId].votesFor = 0;
        issues[issueId].votesAgainst = 0;
        issues[issueId].votesAbstain = 0;
        issues[issueId].totalVotes = 0;
        issues[issueId].passed = false;
        issues[issueId].closed = false;
        
        return issueId;
    }
    
    // Get issue data (returning struct without EnumerableSet)
    function getIssue(uint256 _id) external view returns (ReturnableIssue memory) {
        require(_id < issues.length, "Issue does not exist");
        
        Issue storage issue = issues[_id];
        
        // Convert EnumerableSet to array
        address[] memory votersArray = new address[](issue.voters.length());
        for (uint256 i = 0; i < issue.voters.length(); i++) {
            votersArray[i] = issue.voters.at(i);
        }
        
        return ReturnableIssue({
            voters: votersArray,
            issueDesc: issue.issueDesc,
            votesFor: issue.votesFor,
            votesAgainst: issue.votesAgainst,
            votesAbstain: issue.votesAbstain,
            totalVotes: issue.totalVotes,
            quorum: issue.quorum,
            passed: issue.passed,
            closed: issue.closed
        });
    }
    
    // Vote on an issue
    function vote(uint256 _issueId, Vote _vote) public {
        require(_issueId < issues.length, "Issue does not exist");
        
        Issue storage issue = issues[_issueId];
        
        if (issue.closed) {
            revert VotingClosed();
        }
        
        if (issue.voters.contains(msg.sender)) {
            revert AlreadyVoted();
        }
        
        uint256 voterBalance = balanceOf(msg.sender);
        require(voterBalance > 0, "No tokens held");
        
        // Add voter to the set
        issue.voters.add(msg.sender);
        
        // Add votes based on token balance
        if (_vote == Vote.FOR) {
            issue.votesFor += voterBalance;
        } else if (_vote == Vote.AGAINST) {
            issue.votesAgainst += voterBalance;
        } else {
            issue.votesAbstain += voterBalance;
        }
        
        issue.totalVotes += voterBalance;
        
        // Check if quorum is reached
        if (issue.totalVotes >= issue.quorum) {
            issue.closed = true;
            if (issue.votesFor > issue.votesAgainst) {
                issue.passed = true;
            }
        }
    }
    
    // Helper function to get the number of issues (since issues is now private)
    function getIssuesLength() external view returns (uint256) {
        return issues.length;
    }
}

