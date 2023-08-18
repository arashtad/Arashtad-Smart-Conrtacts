// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract BondingCurveToken is ERC20 {
    uint256 public constant A = 1; // Coefficient A
    uint256 public constant B = 100; // fixed Amount B

    uint256 supply;
    mapping(address => uint256) public balances;

    constructor(string memory name, string memory symbol) ERC20(name, symbol) {}

    function buyTokens() public payable {
        require(msg.value >= getCurrentPrice(), "Insufficient funds, You should at least buy one token");
        uint256 tokenAmount = calculateTokenAmount(msg.value);
        _mint(msg.sender, tokenAmount);
        balances[msg.sender] += tokenAmount;
        supply += tokenAmount;
    }

    function sellTokens(uint256 tokenAmount) public payable{
        uint256 ethAmount = calculateEthAmount(tokenAmount);
        require(balances[msg.sender] >= tokenAmount, "Insufficient balance");
        _burn(payable(msg.sender), tokenAmount);
        balances[msg.sender] -= tokenAmount;
        supply -= tokenAmount;
        payable(msg.sender).transfer(ethAmount);
    }

    function calculateTokenAmount(uint256 ethAmount) public view returns (uint256) {
        uint256 pricePerToken = getCurrentPrice();
        uint256 tokenAmount = ethAmount / pricePerToken;
        return tokenAmount;
    }

    function calculateEthAmount(uint256 tokenAmount) public view returns (uint256) {
        uint256 pricePerToken = getCurrentPrice();
        uint256 ethAmount = tokenAmount * pricePerToken;
        return ethAmount;
    }

    function getCurrentPrice() public view returns (uint256) {
        uint256 price =  A * (supply * supply) + B;
        return price;
    }
    receive() external payable {
    }

    fallback() external payable {
    }
}