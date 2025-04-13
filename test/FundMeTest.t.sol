// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "lib/forge-std/src/Test.sol";
import {FundMe} from "src/FundMe.sol";
import {DeployFundMe} from "script/DeployFundMe.s.sol";

contract FundMeTest is Test{

    FundMe fundMe;

    function setUp() external {
        DeployFundMe deployFundMe= new DeployFundMe();
        fundMe= deployFundMe.run();
    }

    function testMinimumValueIsFive() public{
        assertEq(fundMe.MIN_USD_ALLOWED(), 5 * 10 ** 18);
    }

    function testOwner() public {
        assertEq(fundMe.owner(), msg.sender);
    }
}