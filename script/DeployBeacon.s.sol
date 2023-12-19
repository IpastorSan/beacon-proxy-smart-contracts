// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import {Script, console2} from "forge-std/Script.sol";
import "../src/NFTV1Implementation.sol";
import "../src/BeaconProxyFactory.sol";
import "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";

contract Deploy is Script {

    function setUp() public {

    }

    function run() public {
        vm.startBroadcast();

        NFTV1 implementationV1 = new NFTV1();
        console2.log("Deployed NFTV! Implementation at address: %s", address(implementationV1));

        UpgradeableBeacon beacon = new UpgradeableBeacon(address(implementationV1));
    
        BeaconProxyFactory beaconProxyFactory = new BeaconProxyFactory(address(beacon));

        vm.stopBroadcast();
    }
}
