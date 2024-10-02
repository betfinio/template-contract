// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    constructor(address receiver) ERC20("BET", "BET") {
        _mint(receiver, 777_777_777_777 ether);
    }
}
