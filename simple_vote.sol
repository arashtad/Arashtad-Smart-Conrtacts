// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Voting {
    mapping(address => bool) public hasVoted;
    mapping(string => uint) public voteCount;

    function vote(string memory candidate) public {
        require(!hasVoted[msg.sender], "Already voted");
        voteCount[candidate]++;
        hasVoted[msg.sender] = true;
    }
}