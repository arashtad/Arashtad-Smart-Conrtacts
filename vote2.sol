// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Voting {
    mapping(address => bool) public hasVoted;
    mapping(string => uint) public voteCount;
    string[] public candidates;

    function registerCandidates(string memory candidate) public {
        require(!isCandidate(candidate), "Candidate already registered!");
        candidates.push(candidate);
    }


    function vote(string memory candidate) public {
        require(!hasVoted[msg.sender], "Already voted");
        voteCount[candidate]++;
        hasVoted[msg.sender] = true;
    }

    function isCandidate( string memory candidate) internal view returns (bool) {
        for (uint256 i = 0; i < candidates.length; i++) {
            if (keccak256(bytes(candidates[i])) == keccak256(bytes(candidate))) {
                return true;
            }
        }
        return false;
    }
}