// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {StarcatSwapBridge} from "../src/StarcatSwapBridge.sol";

contract StarcatSwapBridgeScript is Script {
    StarcatSwapBridge public bridge;
    address public l2SwapPoolAddress;

    function setUp() public {
        // Load environment variables
        l2SwapPoolAddress = vm.envAddress("L2_SWAP_POOL_ADDRESS");
    }

    function run() public {
        vm.startBroadcast();

        // Deploy the StarcatSwapBridge contract
        bridge = new StarcatSwapBridge();
        console.log("StarcatSwapBridge deployed at:", address(bridge));

        // Set the L2SwapPoolAddress
        bridge.setL2SwapPoolAddress(l2SwapPoolAddress);
        console.log("L2SwapPoolAddress set to:", l2SwapPoolAddress);

        vm.stopBroadcast();
    }
}