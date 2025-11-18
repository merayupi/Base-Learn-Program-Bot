// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ArraysExercise {
    uint[] public numbers = [1,2,3,4,5,6,7,8,9,10];

    // Arrays for timestamp saving
    address[] public senders;
    uint[] public timestamps;

    // Return the complete numbers array
    function getNumbers() external view returns (uint[] memory) {
        return numbers;
    }

    // Reset numbers array to initial values (1-10)
    // Gas-efficient version without using push()
    function resetNumbers() public {
        // Delete the array first
        delete numbers;
        // Reassign the initial values
        numbers = [1,2,3,4,5,6,7,8,9,10];
    }

    // Append array to existing numbers array
    function appendToNumbers(uint[] calldata _toAppend) external {
        for (uint i = 0; i < _toAppend.length; i++) {
            numbers.push(_toAppend[i]);
        }
    }

    // Save timestamp and sender address
    function saveTimestamp(uint _unixTimestamp) external {
        senders.push(msg.sender);
        timestamps.push(_unixTimestamp);
    }

    // Filter timestamps after Y2K (January 1, 2000, 12:00am)
    function afterY2K() external view returns (uint[] memory recentTimestamps, address[] memory recentSenders) {
        uint y2kTimestamp = 946702800; // January 1, 2000, 12:00am UTC

        // First pass: count how many timestamps are after Y2K
        uint count = 0;
        for (uint i = 0; i < timestamps.length; i++) {
            if (timestamps[i] > y2kTimestamp) {
                count++;
            }
        }

        // Initialize arrays with the correct size
        recentTimestamps = new uint[](count);
        recentSenders = new address[](count);

        // Second pass: fill the arrays
        uint index = 0;
        for (uint i = 0; i < timestamps.length; i++) {
            if (timestamps[i] > y2kTimestamp) {
                recentTimestamps[index] = timestamps[i];
                recentSenders[index] = senders[i];
                index++;
            }
        }

        return (recentTimestamps, recentSenders);
    }

    // Reset senders array
    function resetSenders() public {
        delete senders;
    }

    // Reset timestamps array
    function resetTimestamps() public {
        delete timestamps;
    }
}
