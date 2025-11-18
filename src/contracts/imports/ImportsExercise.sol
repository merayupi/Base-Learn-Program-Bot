// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./SillyStringUtils.sol";

contract ImportsExercise {
    using SillyStringUtils for string;

    // Public instance of Haiku
    SillyStringUtils.Haiku public haiku;

    // Save three strings as haiku lines
    function saveHaiku(
        string memory _line1,
        string memory _line2,
        string memory _line3
    ) external {
        haiku = SillyStringUtils.Haiku({
            line1: _line1,
            line2: _line2,
            line3: _line3
        });
    }

    // Get the haiku as a Haiku type (not individual members)
    function getHaiku() external view returns (SillyStringUtils.Haiku memory) {
        return haiku;
    }

    // Return modified haiku with 🤷 added to line3 (don't modify original)
    function shruggieHaiku() external view returns (SillyStringUtils.Haiku memory) {
        return SillyStringUtils.Haiku({
            line1: haiku.line1,
            line2: haiku.line2,
            line3: SillyStringUtils.shruggie(haiku.line3)
        });
    }
}
