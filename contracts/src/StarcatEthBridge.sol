// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.26;

contract StarcatEthBridge {
    IERC20 public token;
    address public L2BridgeAddress;

    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);

    constructor(IERC20 _token) {
        token = _token;
    }

    function setL2BridgeAddress(address _L2BridgeAddress) external onlyOwner {
        L2BridgeAddress = _L2BridgeAddress;
    }

    function deposit(uint256 amount) external {
        require(token.transferFrom(msg.sender, address(this), amount), "Transfer failed");
        emit Deposit(msg.sender, amount);
    }

    function withdraw(address user, uint256 amount) external onlyOwner {
        require(token.transfer(user, amount), "Transfer failed");
        emit Withdraw(user, amount);
    }
}
