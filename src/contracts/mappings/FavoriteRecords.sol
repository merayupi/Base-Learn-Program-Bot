// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FavoriteRecords {
    // Custom error for non-approved records
    error NotApproved(string albumName);

    // Public mapping to check if records are approved
    mapping(string => bool) public approvedRecords;

    // Nested mapping: user address => (album name => is favorite)
    mapping(address => mapping(string => bool)) public userFavorites;

    // Array to keep track of approved record names for retrieval
    string[] private approvedRecordsList;

    // Array to keep track of each user's favorite records
    mapping(address => string[]) private userFavoritesList;

    constructor() {
        // Load approved records
        string[9] memory recordsToApprove = [
            "Thriller",
            "Back in Black",
            "The Bodyguard",
            "The Dark Side of the Moon",
            "Their Greatest Hits (1971-1975)",
            "Hotel California",
            "Come On Over",
            "Rumours",
            "Saturday Night Fever"
        ];

        for (uint i = 0; i < recordsToApprove.length; i++) {
            approvedRecords[recordsToApprove[i]] = true;
            approvedRecordsList.push(recordsToApprove[i]);
        }
    }

    // Get list of all approved records
    function getApprovedRecords() external view returns (string[] memory) {
        return approvedRecordsList;
    }

    // Add record to user's favorites (only if approved)
    function addRecord(string memory _albumName) external {
        if (!approvedRecords[_albumName]) {
            revert NotApproved(_albumName);
        }

        // Add to user's favorites if not already added
        if (!userFavorites[msg.sender][_albumName]) {
            userFavorites[msg.sender][_albumName] = true;
            userFavoritesList[msg.sender].push(_albumName);
        }
    }

    // Get user's favorite records list
    function getUserFavorites(address _user) external view returns (string[] memory) {
        return userFavoritesList[_user];
    }

    // Reset sender's favorites
    function resetUserFavorites() external {
        // Get the user's current favorites list
        string[] memory currentFavorites = userFavoritesList[msg.sender];

        // Reset the mapping for each favorite
        for (uint i = 0; i < currentFavorites.length; i++) {
            userFavorites[msg.sender][currentFavorites[i]] = false;
        }

        // Clear the user's favorites list
        delete userFavoritesList[msg.sender];
    }
}
