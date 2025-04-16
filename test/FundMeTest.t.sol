// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "lib/forge-std/src/Test.sol";
import {FundMe} from "src/FundMe.sol";
import {DeployFundMe} from "script/DeployFundMe.s.sol";

contract FundMeTest is Test{

    FundMe fundMe;
    uint256 constant AMOUNT_FUNDED= 0.1 ether; //0.1 ether = 100000000000000000 wei
    address USER= makeAddr('user'); //creating a random address to use as a user
    uint256 constant STARTING_BALANCE= 0.2 ether;
    

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

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: AMOUNT_FUNDED}();
        assert(address(fundMe).balance > 0);
        _;
    }

    function testFundUpdatesFundedDataStructure() public funded{

        uint256 amtFunded= fundMe.getAmountAddressFunded(USER);
         assertEq(amtFunded, AMOUNT_FUNDED);
    }

    function testWithdrawalFromSingleFunder() public funded{
        
        //arrange
        uint256 startingFundMeBalance = address(fundMe).balance;
        uint256 startingOwnerBalance = fundMe.getOwner().balance;

        //act     
        vm.prank(fundMe.owner());
        fundMe.withdraw(); //only the owner can withdraw
        
        //assert
        uint256 endingFundMeBalance= address(fundMe).balance;
        uint256 endingOwnerBalance= fundMe.owner().balance;
        assertEq(endingFundMeBalance,0);
        assertEq(endingOwnerBalance, startingOwnerBalance + startingFundMeBalance);
    }

    function testWithdrawlFromMultipleFunder() public funded{

        //arrange
        uint160 numberOfFunders=10; //since addresses's are 20 bytes long similar to uint160
        uint160 startingFunderIndex=2; 
        

        for (uint160 i= startingFunderIndex; i < numberOfFunders + startingFunderIndex; i++){//since we need 10 funders to fund the address
            hoax(address(i), STARTING_BALANCE);
            fundMe.fund{value:AMOUNT_FUNDED}();
        }

        uint256 startingFundMeBalance = address(fundMe).balance;
        uint256 startingOwnerBalance = fundMe.owner().balance;

        //act
        vm.prank(fundMe.owner());
        fundMe.withdraw(); //only the owner can withdraw

        //assert
        assertEq(address(fundMe).balance, 0);
        assert(startingFundMeBalance + startingOwnerBalance == fundMe.getOwner().balance);
        assert((numberOfFunders + 1) * AMOUNT_FUNDED == fundMe.getOwner().balance - startingOwnerBalance);
    }
}