// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "lib/forge-std/src/Script.sol";
import {console} from "liB/forge-std/src/console.sol";
import {FundMe} from "src/FundMe.sol";

contract FundMeScript is Script{
   
    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        FundMe fundme = new FundMe();
        console.log(fundme.Price());

        vm.stopBroadcast();
    }
}




