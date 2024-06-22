// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {TestERC20} from "../src/TestERC20.sol";

contract DeployAndTransferTestERC20 is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        // Deploy the TestERC20 contract with an initial supply of 1,000,000 tokens
        uint256 initialSupply = 1000000 * 10**18;
        TestERC20 token = new TestERC20(initialSupply);
        console.log("TestERC20 deployed at:", address(token));
        console.log("Initial supply:", initialSupply);

        // Define the recipient address and transfer amount
        address recipient = vm.envAddress("USER_EVM_ADDRESS");
        uint256 transferAmount = 1000 * 10**18;

        // Transfer tokens to the recipient
        token.transfer(recipient, transferAmount);
        console.log("Transferred", transferAmount, "tokens to", recipient);

        vm.stopBroadcast();
    }
}