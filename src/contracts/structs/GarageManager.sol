// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract GarageManager {
    // Custom error for invalid car index
    error BadCarIndex(uint256 index);

    // Car struct
    struct Car {
        string make;
        string model;
        string color;
        uint256 numberOfDoors;
    }

    // Public mapping: address => array of Cars
    mapping(address => Car[]) public garage;

    // Add a car to the sender's garage
    function addCar(
        string memory _make,
        string memory _model,
        string memory _color,
        uint256 _numberOfDoors
    ) external {
        Car memory newCar = Car({
            make: _make,
            model: _model,
            color: _color,
            numberOfDoors: _numberOfDoors
        });

        garage[msg.sender].push(newCar);
    }

    // Get all cars for the calling user
    function getMyCars() external view returns (Car[] memory) {
        return garage[msg.sender];
    }

    // Get all cars for any given address
    function getUserCars(address _user) external view returns (Car[] memory) {
        return garage[_user];
    }

    // Update a car at a specific index
    function updateCar(
        uint256 _index,
        string memory _make,
        string memory _model,
        string memory _color,
        uint256 _numberOfDoors
    ) external {
        // Check if the index is valid
        if (_index >= garage[msg.sender].length) {
            revert BadCarIndex(_index);
        }

        // Update the car at the specified index
        garage[msg.sender][_index] = Car({
            make: _make,
            model: _model,
            color: _color,
            numberOfDoors: _numberOfDoors
        });
    }

    // Reset sender's garage (delete all cars)
    function resetMyGarage() public {
        delete garage[msg.sender];
    }
}
