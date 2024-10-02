// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.25 <0.9.0;

import { Test } from "forge-std/src/Test.sol";
import { CoreInterface } from "src/interfaces/CoreInterface.sol";
import { PartnerInterface } from "src/interfaces/PartnerInterface.sol";
import { StakingInterface } from "src/interfaces/StakingInterface.sol";
import { PassInterface } from "src/interfaces/PassInterface.sol";
import { Token } from "src/Token.sol";
import { GameExample } from "src/GameExample.sol";
import { BetExample } from "src/BetExample.sol";

contract ExampleTest is Test {
    // create deployed contract instances
    CoreInterface public core;
    Token public token;
    PassInterface public pass;
    PartnerInterface public partner;
    StakingInterface public conservativeStaking;

    // local variables
    address public alice = address(1);

    // game
    GameExample public game;

    address private deployer = vm.envAddress("DEPLOYER");

    function setUp() public virtual {
        // connect to deployed contracts
        core = CoreInterface(vm.envAddress("CORE"));
        token = Token(vm.envAddress("TOKEN"));
        pass = PassInterface(vm.envAddress("PASS"));
        partner = PartnerInterface(vm.envAddress("PARTNER"));
        conservativeStaking = StakingInterface(vm.envAddress("CONSERVATIVE_STAKING"));
        // fork the blockchain
        vm.createSelectFork({ urlOrAlias: "rpc" });
        // deploy the game
        game = new GameExample(address(conservativeStaking));

        // register the game
        vm.prank(deployer);
        core.addGame(address(game));
    }

    function testGetToken() public virtual {
        assertEq(address(token), core.token());
    }

    function getTokensAndPass(address member, uint256 amount) internal {
        vm.startPrank(deployer);
        token.transfer(member, amount);
        pass.mint(member, deployer, deployer);
        assertEq(token.balanceOf(member), amount);
        assertEq(pass.balanceOf(member), 1);
        vm.stopPrank();
    }

    function testStakeConservative() public {
        getTokensAndPass(alice, 10_000 ether);
        vm.startPrank(alice);
        token.approve(address(core), 10_000 ether);
        partner.stake(address(conservativeStaking), 10_000 ether);
        assertEq(conservativeStaking.getStaked(alice), 10_000 ether);
    }

    function testPlaceBet() public {
        getTokensAndPass(alice, 10 ether);
        vm.startPrank(alice);
        token.approve(address(core), 10 ether);
        bytes memory data = abi.encode(10 ether, alice);
        address betAddress = partner.placeBet(address(game), 10 ether, data);
        assertEq(BetExample(betAddress).getPlayer(), alice);
    }
}
