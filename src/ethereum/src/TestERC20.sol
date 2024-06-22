// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.26;

import {ERC20} from "openzeppelin/token/ERC20/ERC20.sol";

contract TestERC20 is ERC20 {
    constructor(uint256 initialSupply) ERC20("Starcat", "STRC") {
        _mint(msg.sender, initialSupply);
    }
}