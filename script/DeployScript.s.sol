// script/Deploy.s.sol
// SPDX-License-Identifier: BSD-3-Clause
pragma solidity ^0.8.25;

import { Script } from "forge-std/src/Script.sol";
import { console } from "forge-std/src/console.sol";
import { Token } from "../src/Token.sol";

error NoOwnerSet();

contract DeployScript is Script {

    function run() external returns (Token) {
        uint256 chainId = block.chainid;
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployerAddress = vm.envAddress("DEPLOYER");

        // Start broadcasting transactions
        vm.startBroadcast(deployerPrivateKey);

        // Deploy contract with initial rate and owner
        Token token = new Token(deployerAddress);

        vm.stopBroadcast();

        // Log deployment info
        console.log("Deployed Token to:", address(token));
        console.log("Network:", chainId);
        console.log("Owner:", deployerAddress);

        return token;
    }
}
