// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./aggregator.sol";

contract IntegralBondingCurve is ERC20{
    uint256 public constant A = 1;
    uint256 public constant B = 100;
    AggregatorV3Interface public priceFeed;

    uint256 public supply;
    mapping(address => uint256) public balances;

    constructor(string memory name, string memory symbol, address _priceFeed)ERC20(name, symbol){
        priceFeed = AggregatorV3Interface(_priceFeed);
    }

    function buyTokens(uint256 tokenAmount) public payable{
        uint256 ethAmount = calculateEthAmount(tokenAmount, true);
        require(msg.value >= ethAmount, "Insufficient Funds");
        _mint(msg.sender, tokenAmount);
        balances[msg.sender] += tokenAmount;
        supply += tokenAmount;
        payable(msg.sender).transfer(msg.value - ethAmount);
    }
    
    function sellTokens(uint256 tokenAmount) public payable{
        uint256 ethAmount = calculateEthAmount(tokenAmount, false);
        require(balances[msg.sender] >= tokenAmount, "Insufficient Balances");
        _burn(payable(msg.sender), tokenAmount);
        balances[msg.sender] -= tokenAmount;
        supply -= tokenAmount;
        payable(msg.sender).transfer(ethAmount);
    }

    function calculateEthAmount(uint256 tokenAmount, bool buying) public view returns(uint256){
        uint256 initial = 0;
        uint256 f = 0;

        if(buying){
            initial = integrate(supply);
            f = integrate(supply + tokenAmount);
        }else{
            f = integrate(supply);
            initial = integrate(supply - tokenAmount);
        }

        uint256 dollarAmount = f - initial;
        uint256 ethAmount = DollarToWei(dollarAmount);
        return ethAmount;
    }

    function integrate(uint256 number) public pure returns(uint256){
        uint256 result = A * (number ** 3)/3 + B * number;
        return result;
    }

    function DollarToWei(uint256 amountInDollar) public view returns (uint256) {
        (, int256 price, , , ) = priceFeed.latestRoundData();
        uint256 ethPrice = uint256(price);
        uint256 amountInWei = amountInDollar * 10 ** 18 / ethPrice ;
        return amountInWei;
    } 

    function getCurrentPriceInDollar() public view returns(uint256) {
        uint256 price = A * (supply * supply) + B;
        return price;
    }
    receive() external payable {}
    fallback() external payable {}
}