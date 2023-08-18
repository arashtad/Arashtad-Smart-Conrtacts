// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Voting {
    struct Candidate {
        uint256 id;
        string name;
        uint256 voteCount;
    }

    mapping(uint256 => Candidate) public candidates;
    mapping(address => bool) public hasVoted;
    uint256 public totalVotes;
    uint256 public candidatesCount;

    event VoteCasted(uint256 indexed candidateId, address indexed voter);

    constructor(string[] memory _candidatesNames){
        require(_candidatesNames.length > 0, "At least one candidate is required");

        for (uint256 i = 0; i < _candidatesNames.length; i++){
            candidatesCount ++;
            candidates[candidatesCount] = Candidate(candidatesCount, _candidatesNames[i], 0);
        }
    }

    function vote(uint256 _candidatesId) public {
        require(_candidatesId > 0 && _candidatesId <= candidatesCount, "Invalid candidate Id");
        require(!hasVoted[msg.sender], "Already voted");

        Candidate storage candidate = candidates[_candidatesId];
        candidate.voteCount++;
        totalVotes++;
        hasVoted[msg.sender] = true;

        emit VoteCasted(_candidatesId, msg.sender);
    }

    function getCandidate(uint256 _candidatesId) public view returns(uint256, string memory, uint256) {
        require(_candidatesId > 0 && _candidatesId <= candidatesCount, "Invalid candidate ID");
        Candidate memory candidate = candidates[_candidatesId];
        return (candidate.id, candidate.name, candidate.voteCount);
    }
}