// SPDX-Licence-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "lib/forge-std/src/Script.sol";
import {console} from "liB/forge-std/src/console.sol";
import {FundMe} from "src/FundMe.sol";

contract FundMeScript is Script{
    FundMe public fundme;
    
    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        fundme = new FundMe();
        console.log(fundme.Price());

        vm.stopBroadcast();
    }
}




