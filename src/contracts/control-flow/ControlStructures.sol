// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract ControlStructures {
    // Custom error for the doNotDisturb function
    error AfterHours(uint time);
    
    // Smart Contract FizzBuzz function
    function fizzBuzz(uint _number) external pure returns (string memory) {
        if (_number % 15 == 0) {  // Divisible by both 3 and 5 (15)
            return "FizzBuzz";
        } else if (_number % 3 == 0) {  // Divisible by 3
            return "Fizz";
        } else if (_number % 5 == 0) {  // Divisible by 5
            return "Buzz";
        } else {  // None of the above
            return "Splat";
        }
    }
    
    // Do Not Disturb function
    function doNotDisturb(uint _time) external pure returns (string memory) {
        if (_time >= 2400) {
            // Trigger a panic (using assert)
            assert(false);
        }
        
        if (_time > 2200 || _time < 800) {
            // Revert with custom error
            revert AfterHours(_time);
        }
        
        if (_time >= 1200 && _time <= 1259) {
            // Revert with string message
            revert("At lunch!");
        }
        
        if (_time >= 800 && _time <= 1199) {
            return "Morning!";
        }
        
        if (_time >= 1300 && _time <= 1799) {
            return "Afternoon!";
        }
        
        if (_time >= 1800 && _time <= 2200) {
            return "Evening!";
        }
        
        // This should never be reached due to the conditions above
        revert AfterHours(_time);
    }
}
