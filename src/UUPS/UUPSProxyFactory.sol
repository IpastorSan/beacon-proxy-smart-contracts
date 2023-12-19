//SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../interfaces/Inft.sol";

error NonExistingProxy();
error ZeroAddress();
contract UUPSProxyFactory is Ownable {
    uint256 private _proxyId;
    address private _implementation;

    constructor (address implementation) {
        _implementation = implementation;
    }

    function createNewProxy(
        string memory name, 
        string memory symbol, 
        string memory baseURI, 
        uint256 maxSupply, 
        uint256 price
    ) external returns (address) {
        ERC1967Proxy proxy = new ERC1967Proxy{salt: bytes32(_proxyId)}(_implementation, "");
        INFT inft = INFT(address(proxy));
        inft.initialize(name, symbol, baseURI, maxSupply, price, msg.sender);
        _proxyId++;
        return address(proxy);
    }

    function setImplementation(address implementation) external onlyOwner {
        if(implementation == address(0)) revert ZeroAddress();
        _implementation = implementation;
    }

    function getProxyAddress(uint256 proxyId) external view returns (address) {
        if (proxyId > _proxyId) revert NonExistingProxy();

        bytes memory bytecode = type(ERC1967Proxy).creationCode;
        bytecode = abi.encodePacked(bytecode, abi.encode(_implementation,""));
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