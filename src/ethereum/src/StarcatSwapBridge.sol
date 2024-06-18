// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.26;

import {Ownable} from "openzeppelin/access/Ownable.sol";
import {IERC20} from "openzeppelin/token/ERC20/IERC20.sol";

contract StarcatSwapBridge is Ownable {
    address public L2SwapPoolAddress;
    address constant ETH_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    event Swap(address indexed user, address indexed token, uint256 amount, uint256 StarknetAddress);

    constructor() Ownable(msg.sender) {
    }

    function setL2SwapPoolAddress(address _L2SwapPoolAddress) external onlyOwner {
        L2SwapPoolAddress = _L2SwapPoolAddress;
    }

    function swapETH(uint256 StarknetAddress) external payable {
        require(msg.value > 0, "Must send ETH");
        emit Swap(msg.sender, ETH_ADDRESS, msg.value, StarknetAddress);
    }

    function swapERC20(address token, uint256 amount, uint256 StarknetAddress) external {
        require(token != ETH_ADDRESS, "Use swapETH for ETH");
        require(amount > 0, "Amount must be greater than 0");
        
        IERC20(token).transferFrom(msg.sender, address(this), amount);
        emit Swap(msg.sender, token, amount, StarknetAddress);
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function getERC20Balance(address token) external view returns (uint256) {
        return IERC20(token).balanceOf(address(this));
    }
}
