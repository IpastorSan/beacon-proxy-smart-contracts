// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

import "../interfaces/IERC1155Loot.sol";

/// @title A smart contract for ERC1155 objects with Loot metadata
/// @dev Supports base URI string setting.
contract ERC1155Loot is IERC1155Loot, AccessControl, ERC1155 {

    constructor(string memory uri_) ERC1155(uri_) {
        // Admin has the right to grant or revoke roles, including the admin role.
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    /// @notice Sets up a new base URI string
    /**
     * @dev Only an address with the default admin role is authorised to call this function.
     * The new string cannot be empty.
     * Emits a UriUpdated event.
     */
    /// @param newUri New base URI string to set up
    function setUri(string memory newUri) external onlyRole(DEFAULT_ADMIN_ROLE) {
        if (bytes(newUri).length == 0) revert InvalidUri();
        _setURI(newUri);
        emit UriUpdated(newUri);
    }

    /// @notice Mints tokens to the recipient's address.
    /**
     * @dev Only an address with the minter role is authorised to call this function.
     * Emits a TransferSingle event.
     */
    /// @param to Recipient's address
    /// @param id Token id to mint
    /// @param amount Token amount to mint
    /// @param data Additional data to pass on
    function mint(
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) external {
        _mint(to, id, amount, data);
    }

    /// @notice Mints a batch of tokens to the recipient's address.
    /**
     * @dev Only an address with the minter role is authorised to call this function.
     * Emits a TransferBatch event.
     */
    /// @param to Recipient's address
    /// @param ids Token ids to mint
    /// @param amounts Token amounts to mint
    /// @param data Additional data to pass on
    function mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) external {
        _mintBatch(to, ids, amounts, data);
    }

    /// @notice Burns tokens from the source address.
    /**
     * @dev Only an address with the burner role is authorised to call this function.
     * Emits a TransferSingle event.
     */
    /// @param from Source address
    /// @param id Token id to burn
    /// @param amount Token amount to burn
    function burn(
        address from,
        uint256 id,
        uint256 amount
    ) external {
        _burn(from, id, amount);
    }

    /// @notice Burns a batch of tokens from the source address.
    /**
     * @dev Only an address with the burner role is authorised to call this function.
     * Emits a TransferBatch event.
     */
    /// @param from Source address
    /// @param ids Token ids to burn
    /// @param amounts Token amounts to burn
    function burnBatch(
        address from,
        uint256[] memory ids,
        uint256[] memory amounts
    ) external {
        _burnBatch(from, ids, amounts);
    }

    /// @notice Checks whether the contract supports a particular interface
    /// @param interfaceId Interface id to check
    /// @return Returns true if this contract implements the interface defined by `interfaceId`, false otherwise
    function supportsInterface(bytes4 interfaceId) public view virtual override(AccessControl, ERC1155) returns (bool) {
        return interfaceId == type(IERC1155Loot).interfaceId || super.supportsInterface(interfaceId);
    }
}
