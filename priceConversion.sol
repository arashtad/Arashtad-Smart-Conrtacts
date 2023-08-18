// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./aggregator.sol";

contract WeiToDollarConverter {
    AggregatorV3Interface public priceFeed;

    constructor (address _priceFeed){
        priceFeed = AggregatorV3Interface(_priceFeed);
    }

    function ConvertWeiToDollar(uint256 amountInWei) public view returns (uint256) {
        (, int256 price, , , ) = priceFeed.latestRoundData();
        uint256 ethPrice = uint256(price);
        uint256 amountInDollar = amountInWei * ethPrice / 10 ** 18;
        return amountInDollar;
    } 
}