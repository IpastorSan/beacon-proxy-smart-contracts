// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";
import "./utils/Utils.sol";
import "../src/NFTV1Implementation.sol";
import "../src/NFTV2Implementation.sol";
import "../src/BeaconProxyFactory.sol";
import "../src/interfaces/Inft.sol";

contract CounterTest is Test {
    address owner;
    address alice;
    address bob;

    address payable[] public users;
    BeaconProxyFactory beaconProxyFactory;
    UpgradeableBeacon beacon;
    NFTV1 nftV1;
    NFTV2 nftV2;

    function setUp() public {
        Utils utils = new Utils();
        users = utils.createUsers(3);
        owner = users[0];
        alice = users[1];
        bob = users[2];
        vm.label(users[0], "deployer");
        vm.label(users[1], "alice");
        vm.label(users[2], "bob");

        nftV1 = new NFTV1();
        nftV2 = new NFTV2();
        beacon = new UpgradeableBeacon(address(nftV1));
        beaconProxyFactory = new BeaconProxyFactory(address(beacon));
    }

    function testCreateProxy() public {
        address proxy = beaconProxyFactory.createNewProxy("RandomToken", "NFTV1", "ipfs://", 100, 1 ether);
        console2.log("Deployed NFTV1 Proxy at address: %s", address(proxy));
        assertEq(beaconProxyFactory.getProxyAddress(0), proxy);
    }

    function testMintNFTFromProxy() public {
        address proxy = beaconProxyFactory.createNewProxy("RandomToken", "NFTV1", "ipfs://", 100, 1 ether);
        NFTV1 proxyNFT = NFTV1(proxy);
        proxyNFT.mint{value:1 ether}(alice, 1);
        assertEq(proxyNFT.ownerOf(0), alice);
        assertEq(proxyNFT.balanceOf(alice), 1);
    }

    function testChangeImplementationInBeacon() public {
        beacon.upgradeTo(address(nftV2));
        assertEq(beacon.implementation(), address(nftV2));
    } 

    function testNewFunctionalityInV2() public {
        address proxy = beaconProxyFactory.createNewProxy("RandomToken", "NFTV1", "ipfs://", 100, 1 ether);
        NFTV1 proxyNFT = NFTV1(proxy);
        proxyNFT.mint{value:1 ether}(alice, 1);

        beacon.upgradeTo(address(nftV2));
        assertEq(beacon.implementation(), address(nftV2));

        NFTV2 proxyNFTV2 = NFTV2(proxy);
        vm.prank(alice);
        proxyNFTV2.burn(0);
        assertEq(proxyNFTV2.balanceOf(alice), 0);
    } 

    function testV2MultipleProxies() public {
        address proxy1 = beaconProxyFactory.createNewProxy("RandomToken", "NFTV1", "ipfs://", 100, 1 ether);
        address proxy2 = beaconProxyFactory.createNewProxy("RandomToken", "NFTV1", "ipfs://", 100, 1 ether);
        NFTV1 proxyNFT1 = NFTV1(proxy1);
        NFTV1 proxyNFT2 = NFTV1(proxy2);
        proxyNFT1.mint{value:1 ether}(alice, 1);
        proxyNFT2.mint{value:1 ether}(alice, 1);

        beacon.upgradeTo(address(nftV2));
        assertEq(beacon.implementation(), address(nftV2));

        NFTV2 proxyNFTV2_1 = NFTV2(proxy1);
        NFTV2 proxyNFTV2_2 = NFTV2(proxy2);
        vm.startPrank(alice);
        proxyNFTV2_1.burn(0);
        proxyNFTV2_2.burn(0);
        vm.stopPrank();
        assertEq(proxyNFTV2_1.balanceOf(alice), 0);
        assertEq(proxyNFTV2_2.balanceOf(alice), 0);
    } 
}
