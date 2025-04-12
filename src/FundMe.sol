// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;


/*
-> import aggregator, price convertor
-> contructor has owner
-> fund checks for enough money to fund ad adds to contract
-> get aggregator version
-> withdraw funds
-> fallback and revert
*/

import {AggregatorV3Interface} from "lib/chainlink-brownie-contracts/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

contract FundMe{

    using PriceConverter for uint256;
    address public i_owner;
    uint256 price;

    constructor(){
        i_owner = msg.sender;
    }

    function fund(uint256 ethAmount) public payble
}