// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Auction {
    address public auctioneer;
    uint public auctionEndTime;
    address public highestBider;
    uint public highestBid;

    mapping(address => uint) public pendingReturns;

    bool public ended;

    event HighestBidIncreased(address bidder, uint amount);
    event AuctionEnded(address winner, uint amount);

    constructor(uint _biddingTime){
        auctioneer = msg.sender;
        auctionEndTime = block.timestamp + _biddingTime;
    }

    function setBid(uint _bidAmount) public {
        require(!ended , "Auction has already ended");
        require(_bidAmount > highestBid, "There is already a higher bid");

        if(highestBid != 0){
            pendingReturns[highestBider] += highestBid;
        }

        highestBider = msg.sender;
        highestBid = _bidAmount;
        emit HighestBidIncreased(msg.sender, _bidAmount);
    }

    function withdraw() public {
        uint amount = pendingReturns[msg.sender];
        require(amount > 0, " No funds to withdraw");

        pendingReturns[msg.sender] = 0;

        if(!payable(msg.sender).send(amount)){
            pendingReturns[msg.sender] = amount;
        }
    }

    function endAuction() public {
        require(msg.sender == auctioneer, " Only the auctioneer can end the auction");
        require(!ended, "Auction has already ended");

        ended = true;
        emit AuctionEnded(highestBider, highestBid);

        payable(auctioneer).transfer(highestBid);
    }

    receive() external payable{
    }

    fallback() external payable{
    }
}