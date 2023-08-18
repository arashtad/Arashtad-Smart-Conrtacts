// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract SimpleStorage {
    uint8 public number;

    function setNumber(uint8 newNumber) public {
        number = newNumber;
    }
}