// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract BasicMath {
    function adder(uint _a, uint _b) external pure returns (uint sum, bool error) {
        unchecked {
            sum = _a + _b;
            error = sum < _a;
        }
    }

    function subtractor(uint _a, uint _b) external pure returns (uint difference, bool error) {
        if (_a >= _b) {
            difference = _a - _b;
            error = false;
        } else {
            // Base Learn expects 0 when underflow occurs, not the wrapped value
            difference = 0;
            error = true;
        }
    }
}
