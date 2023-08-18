// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract UniqueNames {
    mapping(string => bool) private nameExists;

    event NameAdded(string name);

    function addName(string memory name) public {
        require(!nameExists[name], "name already exists");

        nameExists[name] = true;

        emit NameAdded(name);
    }

    function isNameTaken(string memory name) public view returns (bool){
        return nameExists[name];
    }
}