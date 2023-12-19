//SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin-contracts-upgradeable/contracts/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";
import "./interfaces/Inft.sol";


contract NFTV1 is INFT, ERC721Upgradeable, OwnableUpgradeable {
    uint256 public maxSupply;
    uint256 public price;
    uint256 public tokenId;
    string public baseTokenURI;

    error MintPriceNotPaid();
    error SupplyExceeded();

    constructor() {
        _disableInitializers();
    }

    function initialize(
        string memory name,
        string memory symbol,
        string memory baseURI,
        uint256 initialMaxSupply, 
        uint256 initialPrice,
        address owner
    ) external initializer {

        __ERC721_init_unchained(name, symbol);
        __Ownable_init_unchained();

        baseTokenURI = baseURI;
        maxSupply = initialMaxSupply;
        price = initialPrice;
        transferOwnership(owner);
    }

    function mint(address to, uint256 amount) external payable onlyOwner {
        uint256 currentId = tokenId;

        if(currentId + amount > maxSupply) revert SupplyExceeded();
        if(msg.value != price * amount) revert MintPriceNotPaid();

        tokenId += amount;

        for (uint256 i= 0; i < amount; i++){
            _mint(to, currentId + i);
        }
    }

    function _baseURI() internal view override returns (string memory) {
       return baseTokenURI;
    }

    function withdraw() external onlyOwner {
     uint256 balance = address(this).balance;
     require(balance > 0, "No ether left to withdraw");

     (bool success, ) = payable(owner()).call{value: balance}("");

     require(success, "Transfer failed.");
    }
}