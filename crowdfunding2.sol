// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract CrowdFunding {
    address public projectOwner;
    uint256 public goalAmount;
    uint256 public currentAmount;
    mapping(address => uint256) public contributions;
    bool public campaignClosed;

    event ContributionsRecieved(address contributor, uint256 amount);
    event CampaignClosed(bool successful);

    constructor(uint256 _goalAmount) {
        projectOwner = msg.sender;
        goalAmount =  _goalAmount;
        currentAmount = 0;
        campaignClosed = false;
    }

    function contribute(uint256 amount) public payable {
        require(!campaignClosed, "Campaign is closed");
        require(amount > 0, "Invalid Contribution amount");
        require(msg.value <= amount, "incorrect contribution value");

        contributions[msg.sender] += amount;
        currentAmount += amount;

        emit ContributionsRecieved(msg.sender,amount);

        if (currentAmount >= goalAmount){
            campaignClosed = true;
            emit CampaignClosed(true);
        }
    }

    function withdrawFunds() public {
        require(campaignClosed, "Campaign is still open");
        //require(contributions[msg.sender] > 0, "No contributions to withdraw");

        uint256 amount = contributions[msg.sender];
        contributions[msg.sender] = 0;

        payable(msg.sender).transfer(amount);
    }

    receive() external payable{
    }

    fallback() external payable{
    }
}