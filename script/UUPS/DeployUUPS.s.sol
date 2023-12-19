// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import {Script, console2} from "forge-std/Script.sol";
import "../../src/UUPS/NFTV1UUPS.sol";
import "../../src/UUPS/UUPSProxyFactory.sol";

contract Deploy is Script {

    function setUp() public {

    }

    function run() public {
        vm.startBroadcast();

        NFTV1UUPS implementationV1 = new NFTV1UUPS();
        console2.log("Deployed NFTV1 Implementation at address: %s", address(implementationV1));
    
        UUPSProxyFactory uupsProxyFactory = new UUPSProxyFactory(address(implementationV1));

        vm.stopBroadcast();
    }
}
