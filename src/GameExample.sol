// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import { GameInterface } from "./interfaces/GameInterface.sol";
import { StakingInterface } from "./interfaces/StakingInterface.sol";
import { BetExample } from "./BetExample.sol";

/**
 * Errors:
 * GE01: Invalid player
 * GE02: Invalid amount
 */
contract GameExample is GameInterface {
    uint256 private immutable created;

    StakingInterface public staking;

    constructor(address _staking) {
        created = block.timestamp;
        staking = StakingInterface(_staking);
    }

    function placeBet(
        address player,
        uint256 amount,
        bytes calldata data
    )
        external
        override
        returns (address betAddress)
    {
        (uint256 _amount, address _player) = abi.decode(data, (uint256, address));
        require(_player == player, "GE01");
        require(_amount == amount, "GE02");
        BetExample bet = new BetExample(_player, amount, address(this));
        return address(bet);
    }

    function getAddress() external view override returns (address gameAddress) {
        return address(this);
    }

    function getVersion() external view override returns (uint256 version) {
        return created;
    }

    function getFeeType() external pure override returns (uint256 feeType) {
        return 0;
    }

    function getStaking() external view override returns (address) {
        return address(staking);
    }
}
