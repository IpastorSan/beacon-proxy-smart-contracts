//SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

interface INFT {
    function initialize(
        string memory name, 
        string memory symbol, 
        string memory baseURI, 
        uint256 maxSupply, 
        uint256 price, 
        address owner
    ) external;

    function mint(address to, uint256 amount) external payable;

    function withdraw() external;
}