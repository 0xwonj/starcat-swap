// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {StarcatSwapBridge} from "../src/StarcatSwapBridge.sol";
import {IERC20} from "openzeppelin/token/ERC20/IERC20.sol";

contract TestStarcatSwapBridge is Script {
    StarcatSwapBridge public bridge;
    address public bridgeAddress;
    address public user;
    uint256 public starknetAddress;
    IERC20 public token;

    function setUp() public {
        // Load environment variables
        bridgeAddress = vm.envAddress("EVM_BRIDGE_ADDRESS");
        user = vm.envAddress("EVM_USER_ADDRESS");
        starknetAddress = vm.envUint("STARKNET_USER_ADDRESS");
        address tokenAddress = vm.envAddress("EVM_TOKEN_ADDRESS");

        // Initialize the contract instance
        bridge = StarcatSwapBridge(bridgeAddress);
        token = IERC20(tokenAddress);
    }

    function testSwapETH() public {
        vm.startBroadcast(user);

        // Send a transaction to swap ETH
        uint256 amount = 0.01 ether;
        bridge.swapETH{value: amount}(starknetAddress);
        console.log("Sent swapETH transaction with amount:", amount);

        vm.stopBroadcast();
    }

    function testSwapERC20() public {
        vm.startBroadcast(user);

        // Approve and send a transaction to swap ERC20 tokens
        uint256 amount = 100 * 10**18;
        token.approve(bridgeAddress, amount);
        bridge.swapERC20(address(token), amount, starknetAddress);
        console.log("Sent swapERC20 transaction with amount:", amount);

        vm.stopBroadcast();
    }

    function testSetL2SwapPoolAddress() public {
        vm.startBroadcast();

        // Set the L2SwapPoolAddress
        address newL2SwapPoolAddress = 0x1234567890123456789012345678901234567890;
        bridge.setL2SwapPoolAddress(newL2SwapPoolAddress);
        console.log("L2SwapPoolAddress set to:", newL2SwapPoolAddress);

        vm.stopBroadcast();
    }

    function run() public {
        // Call the test functions
        testSwapETH();
        testSwapERC20();
        testSetL2SwapPoolAddress();
    }
}