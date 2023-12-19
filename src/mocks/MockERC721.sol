//SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";



contract MockERC721 is ERC721, Ownable {

    constructor(address receiver) ERC721("RandomNFT721", "RNFT") {
        mint(owner(), 10);
    }

    function mint(address to, uint256 amount) internal {
        for (uint256 i= 0; i < amount; i++){
            _mint(to, i);
        }
    }
}