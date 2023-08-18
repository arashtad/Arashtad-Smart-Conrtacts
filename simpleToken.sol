// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract simpleToken {
    mapping(address => uint256) public balances;

    event Transfer(address indexed from, address indexed to, uint256 value);

    constructor(uint256 initialSupply) {
        balances[msg.sender] = initialSupply;
    }

    function transfer(address to, uint256 value) public {
        require(balances[msg.sender] >= value, "Insufficient Funds");

        balances[msg.sender] -= value;
        balances[to] += value;

        emit Transfer(msg.sender, to, value);
    }
}