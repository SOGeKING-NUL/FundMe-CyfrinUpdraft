// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {AggregatorV3Interface} from "lib/chainlink-brownie-contracts/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter{


    function getPrice(AggregatorV3Interface priceFeed) internal view returns (uint256){

            (, int256 answer, , , ) = priceFeed.latestRoundData();
            return uint256(answer * 10000000000); //only 8 decimal places, have to make 10e18
        }

    function getConversionRate(uint256 ethAmount, AggregatorV3Interface priceFeed) internal view returns (uint256){

        uint256 ethPrice = getPrice(priceFeed);
        uint256 rate = (ethPrice*ethAmount)/1000000000000000000;
        return rate;
    }
}