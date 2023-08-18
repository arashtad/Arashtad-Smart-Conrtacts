// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract DecentralizedExchange {
    address public owner;
    mapping(address => uint256) balances;

    event Deposit(address indexed aaccount, uint256 amount);
    event Withdrawal(address indexed account, uint256 amount);
    event Trade(address indexed buyer,address indexed seller, uint256 amount, uint256 price);

    constructor() {
        owner = msg.sender;
    }

    function deposit(uint256 amount) public payable {
        require(amount > 0 , "Invalid deposit amount");

        balances[msg.sender] += amount;

        emit Deposit(msg.sender, amount);
    }

    function withdraw(uint256 amount) public {
        require(amount > 0, "Invalid withdarawal amount");
        require(amount <= balances[msg.sender], "Insufficient balance");
        
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);

        emit Withdrawal(msg.sender, amount);
    }

    function trade(address seller, uint256 amount, uint256 price) public {
        require(seller != address(0), "Invalid seller address");
        require(seller != msg.sender, "Cannot trade with yourself");
        require(balances[msg.sender] >= amount, "Insufficient funds");

        uint256 totalAmount = amount * price;
        require(balances[seller] >= totalAmount, "Seller has Insufficient balance");

        balances[msg.sender] -= amount;
        balances[seller] -= totalAmount;
        balances[msg.sender] += totalAmount;

        emit Trade(msg.sender, seller, amount, price);
    }
    receive() external payable{}
    fallback() external payable{}

}