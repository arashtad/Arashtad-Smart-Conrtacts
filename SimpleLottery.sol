// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Lottery{
    address public manager;
    address public winnerAddress;
    address[] public players;

    constructor() {
        manager = msg.sender;
    }

    function enter() public payable{
        players.push(msg.sender);
    }

    function getPlayers() public view returns (address[] memory) {
        return players;
    }

    function pickWinner() public restricted {
        require(players.length > 0, "No players in the lottery");
        uint256 index = random()%players.length;
        winnerAddress = players[index];
        players = new address[](0);
    }

    modifier restricted() {
        require(msg.sender == manager, "Restricted to the manager");
        _;
    }

    function random() private view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.basefee, block.timestamp, players.length)));
    }
}