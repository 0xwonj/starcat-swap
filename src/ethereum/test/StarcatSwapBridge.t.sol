// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {StarcatSwapBridge} from "../src/StarcatSwapBridge.sol";
import {IERC20} from "openzeppelin/token/ERC20/IERC20.sol";

contract MockERC20 is IERC20 {
    string public name = "MockERC20";
    string public symbol = "MERC20";
    uint8 public decimals = 18;
    uint256 public totalSupply = 1000000 * 10**18;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    constructor() {
        balanceOf[msg.sender] = totalSupply;
    }

    function transfer(address recipient, uint256 amount) external returns (bool) {
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
        require(balanceOf[sender] >= amount, "Insufficient balance");
        require(allowance[sender][msg.sender] >= amount, "Allowance exceeded");
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        allowance[sender][msg.sender] -= amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }
}

contract StarcatSwapBridgeTest is Test {
    StarcatSwapBridge public bridge;
    MockERC20 public token;

    address public user = address(0x123);
    uint256 public starknetAddress = 0x456;

    function setUp() public {
        bridge = new StarcatSwapBridge();
        token = new MockERC20();
        bridge.setL2SwapPoolAddress(address(this));
    }

    function test_SetL2SwapPoolAddress() public {
        address newL2SwapPoolAddress = address(0x789);
        bridge.setL2SwapPoolAddress(newL2SwapPoolAddress);
        assertEq(bridge.L2SwapPoolAddress(), newL2SwapPoolAddress);
    }

    function test_SwapETH() public {
        uint256 amount = 1 ether;
        vm.deal(user, amount);
        vm.prank(user);
        bridge.swapETH{value: amount}(starknetAddress);
        assertEq(bridge.getBalance(), amount);
    }

    function test_SwapERC20() public {
        uint256 amount = 100 * 10**18;
        token.transfer(user, amount);
        vm.prank(user);
        token.approve(address(bridge), amount);
        vm.prank(user);
        bridge.swapERC20(address(token), amount, starknetAddress);
        assertEq(bridge.getERC20Balance(address(token)), amount);
    }

    function test_GetBalance() public {
        uint256 amount = 1 ether;
        vm.deal(user, amount);
        vm.prank(user);
        bridge.swapETH{value: amount}(starknetAddress);
        assertEq(bridge.getBalance(), amount);
    }

    function test_GetERC20Balance() public {
        uint256 amount = 100 * 10**18;
        token.transfer(user, amount);
        vm.prank(user);
        token.approve(address(bridge), amount);
        vm.prank(user);
        bridge.swapERC20(address(token), amount, starknetAddress);
        assertEq(bridge.getERC20Balance(address(token)), amount);
    }
}