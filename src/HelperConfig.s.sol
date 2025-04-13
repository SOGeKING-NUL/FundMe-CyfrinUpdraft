//SPDX-Licence0-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "lib/forge-std/src/Script.sol";

contract HelperConfig{

    struct NetworkConfig{
        address priceFeed;
    }

    NetworkConfig public activeNetworkConfig;

    constructor

}