// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract bondingCurve2 is ERC20{
    uint256 public constant A = 1;
    uint256 public constant B = 100;

    uint256 public supply;
    mapping(address => uint256) public balances;

    constructor(string memory name, string memory symbol) ERC20(name,symbol){}

    function buyTokens(uint256 tokenAmount) public payable{
        uint256 ethAmount = calculateEthAmount(tokenAmount, true);
        require(msg.value >= ethAmount, "Insufficient Funds");
        _mint(msg.sender, tokenAmount);
        balances[msg.sender] += tokenAmount;
    }

    function sellTokens(uint256 tokenAmount) public payable{
        uint256 ethAmount = calculateEthAmount(tokenAmount, false);
        require(balances[msg.sender] >= tokenAmount, "Insufficient Balances");
        _burn(payable(msg.sender), tokenAmount);
        balances[msg.sender] -= tokenAmount;
        payable(msg.sender).transfer(ethAmount);
    }

    function calculateEthAmount(uint256 tokenAmount, bool buying) public returns(uint256){
        uint256 pricePerToken = getCurrentPrice();
        uint256 ethAmount = pricePerToken;
        for (uint256 i = 0; i < tokenAmount; i++){
            if(buying){
                supply += 1;
            }else{
                supply -= 1;
            }
            ethAmount += getCurrentPrice();
        }
        return ethAmount;
    }

    function getCurrentPrice() public view returns(uint256) {
        uint256 price = A * (supply * supply) + B;
        return price;
    }
    
    receive() external payable {}
    fallback() external payable {}
}