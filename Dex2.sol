// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IERC20{
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract DecentralizedExchange {
    address public owner;
    mapping(address => uint256) public balances;

    event Deposit(address indexed account, uint256 amount);
    event Withdarawal(address indexed account, uint256 amount);
    event Trade(address indexed buyer, address indexed seller, uint256 amount, uint256 price);

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {
        deposit(msg.value);
    }

    fallback() external payable {
        deposit(msg.value);
    }

    function deposit(uint256 amount) public payable {
        require(amount > 0, "Invalid deposit amount");

        balances[msg.sender] += amount;

        emit Deposit(msg.sender, amount);
    }

    function withdraw(uint256 amount) public {
        require(amount > 0, "Invalid withdrawal amount");
        require(amount <= balances[msg.sender], "Insufficient balance");

        balances[msg.sender] -= amount;

        payable(msg.sender).transfer(amount);

        emit Withdarawal(msg.sender, amount);
    }

    function trade(address tokenAddress, uint256 amount, uint256 price) public payable {
            require(tokenAddress != address(0), "Invalid token address");
            require(amount > 0, "Invalid amount");
            require(balances[msg.sender] >= amount, "Insufficient funds");

            emit Trade(msg.sender, tokenAddress, amount, price);
    }
    

}