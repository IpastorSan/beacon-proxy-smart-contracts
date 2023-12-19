//SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin-contracts-upgradeable/contracts/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";


error MintPriceNotPaid();
error SupplyExceeded();

//@dev This new version of the contract includes a new burn functionality
contract NFTV2UUPS is ERC721Upgradeable, OwnableUpgradeable, UUPSUpgradeable {
    uint256 public immutable max_supply;
    uint256 public immutable price;
    uint256 public tokenId;
    string public baseTokenURI;

    constructor() {
        _disableInitializers();
    }

    function initialize(
        string memory name,
        string memory symbol,
        string memory baseURI,
        uint256 initial_max_supply, 
        uint256 initial_price,
        address owner
    ) external initializer {

        __ERC721_init_unchained(name, symbol);
        __Ownable_init_unchained(owner);

        baseTokenURI = baseURI;
        max_supply = initial_max_supply;
        price = initial_price;
    }

    function mint(address to, uint256 amount) external onlyOwner {
        uint256 currentId = tokenId;
        
        if(currentId + amount > max_supply) revert SupplyExceeded();
        if(msg.value != price * amount) revert MintPriceNotPaid();

        tokenId += amount;

        for (uint256 i= 0; i < amount; i++){
            _mint(to, currentId + i);
        }
    }

    function withdraw() external onlyOwner {
     uint256 balance = address(this).balance;
     require(balance > 0, "No ether left to withdraw");

     (bool success, ) = payable(owner()).call{value: balance}("");

     require(success, "Transfer failed.");
    }

    function burn(uint256 token) external {
        _update(address(0), token, _msgSender());
    }
    
    function _authorizeUpgrade(address) internal override onlyOwner {}
    
    function _baseURI() internal view override returns (string memory) {
       return baseTokenURI;
    }


}