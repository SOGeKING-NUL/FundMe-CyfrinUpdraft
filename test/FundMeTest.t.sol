// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "lib/forge-std/src/Test.sol";
import {FundMe} from "src/FundMe.sol";
import {DeployFundMe} from "script/DeployFundMe.s.sol";

contract FundMeTest is Test{

    FundMe fundMe;
    uint256 constant AMOUNT_FUNDED= 1 ether; //0.1 ether = 100000000000000000 wei
    address USER= makeAddr('user'); //creating a random address to use as a user
    uint256 constant STARTING_BALANCE= 20 ether;
    

    function setUp() external {
        DeployFundMe deployFundMe= new DeployFundMe();
        fundMe= deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE); //giving the user some ether to fund the contract

    }

    function testMinimumValueIsFive() public{
        assertEq(fundMe.MIN_USD_ALLOWED(), 5 * 10 ** 18);
    }

    function testOwner() public {
        assertEq(fundMe.owner(), msg.sender);
    }

    function testRevertIfLessThanFive() public {
        vm.expectRevert();
        fundMe.fund{value: 0.00024 ether}();
    }

    function testFundUpdatesFundedDataStructure() public{

        vm.prank(USER);
        fundMe.fund{value: AMOUNT_FUNDED}();
        uint256 amtFunded= fundMe.getAmountAddressFunded(USER);
        assertEq(amtFunded, AMOUNT_FUNDED);


    }

}