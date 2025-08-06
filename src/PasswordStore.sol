// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

/**
 * @title PasswordStore
 * @author not-so-secure-dev
 * @notice This contract securely stores a password hash instead of the plain password.
 * @dev Passwords are stored as keccak256 hashes to improve security.
 */
contract PasswordStore {
    error PasswordStore__NotOwner();

    address private immutable i_owner; // Owner address, immutable after deployment
    bytes32 private s_passwordHash; // Stored hashed password

    event PasswordChanged();

    /**
     * @dev Sets the deployer as the owner
     */
    constructor() {
        i_owner = msg.sender;
    }

    /**
     * @notice Sets a new password (hashed)
     * @param newPassword The new password in plain text which will be hashed inside the contract
     * @dev Only callable by the owner
     */
    function setPassword(string calldata newPassword) external {
        if (msg.sender != i_owner) {
            revert PasswordStore__NotOwner();
        }
        s_passwordHash = keccak256(abi.encodePacked(newPassword));
        emit PasswordChanged();
    }

    /**
     * @notice Checks if the input password matches the stored password hash
     * @param inputPassword The password to verify
     * @return True if the password matches, false otherwise
     * @dev Only callable by the owner
     */
    function checkPassword(
        string calldata inputPassword
    ) external view returns (bool) {
        if (msg.sender != i_owner) {
            revert PasswordStore__NotOwner();
        }
        return keccak256(abi.encodePacked(inputPassword)) == s_passwordHash;
    }
}
