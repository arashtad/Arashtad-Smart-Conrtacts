// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Escrow {
    address public buyer;
    address public seller;
    address public arbiter;
    bool public releaseFunds;

    constructor(address _seller, address _arbiter) {
        buyer = msg.sender;
        seller = _seller;
        arbiter = _arbiter;
    }

    function releaseAmount() public {
        require(msg.sender == buyer || msg.sender == arbiter, "Not Authorized!");
        releaseFunds = true;
    }

    function refundAmount() public {
        require(msg.sender == seller || msg.sender == arbiter, "Not Authorized!");
        releaseFunds = false;
    }
}