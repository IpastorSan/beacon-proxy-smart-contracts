//SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/Inft.sol";

contract BeaconProxyFactory is Ownable {
    uint256 private _proxyId;
    address private _beacon;

    constructor (address beacon) {
        _beacon = beacon;
    }

    function createNewProxy(
        string memory name, 
        string memory symbol, 
        string memory baseURI, 
        uint256 maxSupply, 
        uint256 price
    ) external returns (address) {
        BeaconProxy proxy = new BeaconProxy{salt: bytes32(_proxyId)}(_beacon, "");
        INFT inft = INFT(address(proxy));
        inft.initialize(name, symbol, baseURI, maxSupply, price, msg.sender);
        _proxyId++;
        return address(proxy);
    }
    function getProxyAddress(uint256 proxyId) external view returns (address) {
        bytes memory bytecode = type(BeaconProxy).creationCode;
        bytecode = abi.encodePacked(bytecode, abi.encode(_beacon,""));
        bytes32 hash = keccak256(
            abi.encodePacked(
                bytes1(0xff),
                address(this),
                proxyId,
                keccak256(bytecode)
            )
        );

        return address(uint160(uint256(hash)));
    }
    function getCurrentProxyId() external view returns (uint256) {
        return _proxyId;
    }
}