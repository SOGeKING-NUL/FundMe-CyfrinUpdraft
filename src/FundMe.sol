// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "lib/chainlink-brownie-contracts/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

contract FundMe{

    using PriceConverter for uint256;
    address public owner;
    mapping(address => uint256) public AmountAddressFunded;
    uint256 public MIN_USD_ALLOWED= 5 * 10 ** 18;
    address[] public funders;
    AggregatorV3Interface private s_priceFeed;

    constructor(address priceFeed){
        owner = msg.sender;
        s_priceFeed= AggregatorV3Interface(priceFeed); //pricefeed is the contract address at which the price is deployed on a network
    }

    function fund() public payable{
        require(PriceConverter.getConversionRate(msg.value, s_priceFeed) >= MIN_USD_ALLOWED,  "Alteast donate 5 Dollar worth of ETH");
        AmountAddressFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }

    function withdraw() public onlyOwner payable{
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++ ){
            address funder = funders[funderIndex];
            AmountAddressFunded[funder]= 0;            
        }

        funders = new address[](0);
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