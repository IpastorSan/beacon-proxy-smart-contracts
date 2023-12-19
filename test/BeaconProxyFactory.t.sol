// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";
import "./utils/Utils.sol";
import "../src/NFTV1Implementation.sol";
import "../src/NFTV2Implementation.sol";
import "../src/BeaconProxyFactory.sol";

contract CounterTest is Test {
    address payable[] public users;

    function setUp() public {
        Utils utils = new Utils();
        users = utils.createUsers(3);
        vm.label(users[0], "deployer");
        vm.label(users[1], "alice");
        vm.label(users[2], "bob");

        NFTV1 implementationV1 = new NFTV1();
        UpgradeableBeacon beacon = new UpgradeableBeacon(address(implementationV1));
        BeaconProxyFactory beaconProxyFactory = new BeaconProxyFactory(address(beacon));
    }

    function testCreateProxy() public {

    }

    function testFuzz_SetNumber(uint256 x) public {
   
    }
}
