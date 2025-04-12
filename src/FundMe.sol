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
    address public owner;
    mapping(uint256 => address) public AddressFunded;
    uint256 price;

    constructor(){
        owner = msg.sender;
    }

    function fund() public payable{
        require(PriceConverter.getConversionRate(msg.value) >= 1,  "Alteast donate 1 Dollar worth of ETH");

    }

    function withdraw() public onlyOwner payable{

    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _; //to let the conde execute after too
    }

    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }
}