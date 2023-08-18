// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract SimpleContract{
    string public data;

    constructor(string memory _data) {
        data = _data;
    }
}

contract SimpleContractFactory{
    event ContractCreated( address indexed newContract, string data);

    function createContract(string memory _data) public{
        SimpleContract newContract = new SimpleContract(_data);
        emit ContractCreated(address(newContract), _data);
    }
}