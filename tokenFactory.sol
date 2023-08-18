// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Token {
    string public name;
    string public symbol;
    uint public totalSupply;
    mapping(address => uint) public balances;

    constructor(string memory _name, string memory _symbol, uint _totalSupply) {
        name = _name;
        symbol = _symbol;
        totalSupply = _totalSupply;
        balances[msg.sender] = _totalSupply;
    }
}

contract TokenFactory {
    event TokenCreated(address indexed tokenAddress, string name, string symbol, uint totalSupply);

    function createToken(string memory _name, string memory _symbol, uint _totalSupply) public {
        Token newToken = new Token(_name, _symbol, _totalSupply);
        emit TokenCreated(address(newToken), _name, _symbol, _totalSupply);
    }

}




