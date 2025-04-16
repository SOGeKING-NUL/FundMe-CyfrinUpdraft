// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "lib/chainlink-brownie-contracts/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

contract FundMe{

    using PriceConverter for uint256;
    address public owner;
    mapping(address => uint256) private s_AmountAddressFunded;
    uint256 public MIN_USD_ALLOWED= 5 * 10 ** 18;
    address[] private s_funders;
    AggregatorV3Interface private s_priceFeed;

    constructor(address priceFeed){
        owner = msg.sender;
        s_priceFeed= AggregatorV3Interface(priceFeed); //pricefeed is the contract address at which the price is deployed on a network
    }

    function fund() public payable{
        require(PriceConverter.getConversionRate(msg.value, s_priceFeed) >= MIN_USD_ALLOWED,  "Alteast donate 5 Dollar worth of ETH");
        s_AmountAddressFunded[msg.sender] += msg.value;
        s_funders.push(msg.sender);
    }

    function withdraw() public onlyOwner payable{
        for (uint256 funderIndex = 0; funderIndex < s_funders.length; funderIndex++ ){
            address funder = s_funders[funderIndex];
            s_AmountAddressFunded[funder]= 0;            
        }

        s_funders = new address[](0);
        (bool success,)= payable(owner).call{value: address(this).balance}("");
        require(success, "Transfer Failed");
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _; //to let the conde execute after too
    }

    function getOwner() external view returns(address){
        return owner;
    }

    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }


    //getter functions
    function getAmountAddressFunded(address funder) external view returns(uint256){
        return s_AmountAddressFunded[funder];
    }

    function getFunder (uint256 index) external view returns(address){
        return s_funders[index];
    }
}