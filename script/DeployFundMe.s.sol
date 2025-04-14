// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "lib/forge-std/src/Script.sol";
import {console} from "liB/forge-std/src/console.sol";
import {FundMe} from "src/FundMe.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";

contract DeployFundMe is Script{

   
    function run() external returns (FundMe){     

        HelperConfig helperConfig= new HelperConfig();   
        address ethUsdPriceFeed = helperConfig.activeNetworkConfig();
        
        vm.startBroadcast();
        FundMe fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        vm.stopBroadcast();
        return (fundMe);
    }
}




