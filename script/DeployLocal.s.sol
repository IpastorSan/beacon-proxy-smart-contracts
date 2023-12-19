// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import {Script, console2} from "forge-std/Script.sol";
import {Counter} from "../src/Counter.sol";
import {MockERC20} from "../src/mocks/MockERC20.sol";

contract Deploy is Script {

    address private deployer;
    address private alice;
    address private bob;
    function setUp() public {
        deployer = vm.envAddress("DEPLOYER");
        alice = vm.envAddress("ALICE");
        bob = vm.envAddress("BOB");
    }

    function run() public {
        vm.startBroadcast();

        //Deploy mockERC20 and attach 1000 to every address
        MockERC20 mockERC20 = new MockERC20(new address[](0), new uint256[](0));
        console2.log("Deployed MockERC20 at address: %s", address(mockERC20));
        mockERC20.mint(deployer, 1000 ether);
        mockERC20.mint(alice, 500 ether);
        mockERC20.mint(bob, 100 ether);

        //Deploy Counter
        Counter counter = new Counter();

        vm.stopBroadcast();
    }
}
