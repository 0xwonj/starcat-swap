// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.26;

import {Ownable} from "openzeppelin/access/Ownable.sol";

contract StarcatEthBridge is Ownable {
    address public L2BridgeAddress;

    event Swap(address indexed user, uint256 amount, uint256 StarknetAddress);

    modifier onlyL2Bridge() {
        require(msg.sender == L2BridgeAddress, "Caller is not L2Bridge");
        _;
    }

    constructor() Ownable(msg.sender) {
    }

    function setL2BridgeAddress(address _L2BridgeAddress) external onlyOwner {
        L2BridgeAddress = _L2BridgeAddress;
    }

    function swap(uint256 StarknetAddress) external payable {
        require(msg.value > 0, "Must send ETH");
        emit Swap(msg.sender, msg.value, StarknetAddress);
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
