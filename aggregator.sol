// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface AggregatorV3Interface {
    function latestRoundData() external view returns(
        uint80 roundId,
        int256 answer,
        uint256 startedAt,
        uint256 updatedAt,
        uint80 answeredInRound
    );
}

contract MockPriceFeed is AggregatorV3Interface {
    int256 private _mockPrice;

    constructor(int256 initialPrice){
        _mockPrice = initialPrice;
    }

    function latestRoundData() external view override returns(
        uint80 roundId,
        int256 answer,
        uint256 startedAt,
        uint256 updatedAt,
        uint80 answeredInRound        
    ){
        roundId = 0;
        answer = _mockPrice;
        startedAt = 0;
        updatedAt = block.timestamp;
        answeredInRound = 0;
    }

    function serPrice(int256 price) external{
        _mockPrice = price;
    }
}