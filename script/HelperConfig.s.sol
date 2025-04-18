// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "lib/forge-std/src/Script.sol";
import {MockV3Aggregator} from "test/mock/MockV3Aggregator.sol";

contract HelperConfig is Script {
    //helps deploy and check the price as well as the contract on different networks
    //doing this helps reduce the amount of RPC calls we make to the sepolia network
    struct NetworkConfig {
        address priceFeed;
    }

    NetworkConfig public activeNetworkConfig;
    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8; //2000$

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else if (block.chainid == 1) {
            activeNetworkConfig = getMainnetConfig();
        } else {
            activeNetworkConfig = createActiveAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public view returns (NetworkConfig memory) {
    NetworkConfig memory sepoliaConfig= NetworkConfig({
        priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
    return sepoliaConfig;
    }

    function getMainnetConfig() public view returns (NetworkConfig memory) {
        NetworkConfig memory mainnetConfig= NetworkConfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
            });
        return mainnetConfig;
        }

    function createActiveAnvilEthConfig() public returns (NetworkConfig memory) {

        if(activeNetworkConfig.priceFeed != address(0)){
            return activeNetworkConfig;
        }

        vm.startBroadcast();
        // Deploying the mock price feed contract
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({priceFeed: address(mockPriceFeed)});
        return anvilConfig; 


    }
}

