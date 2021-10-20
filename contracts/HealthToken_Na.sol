// SPDX-License-Identifier: MIT

pragma solidity ^0.8.2;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Snapshot.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract HLTHToken is AccessControl, ERC20Snapshot, Pausable {
    using SafeMath for uint256;

    bytes32 public constant PAUSE_ROLE = keccak256("PAUSE_ROLE");

    bytes32 public constant SNAPSHOT_ROLE = keccak256("SNAPSHOT_ROLE");

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");

    mapping(address => bool) private frozen;

    constructor( ) AccessControl() ERC20Snapshot() ERC20("HLTH Token" , "HLTH") {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setRoleAdmin(PAUSE_ROLE, DEFAULT_ADMIN_ROLE);
        _setRoleAdmin(SNAPSHOT_ROLE, DEFAULT_ADMIN_ROLE);
        _setRoleAdmin(MINTER_ROLE, DEFAULT_ADMIN_ROLE);
        _setRoleAdmin(BURNER_ROLE, DEFAULT_ADMIN_ROLE);
    }

    function createSnapshot() external onlyRole(SNAPSHOT_ROLE) returns (uint256) {
        return _snapshot();
    }

    function pauseToken() external onlyRole(PAUSE_ROLE) returns (bool) {
        _pause();
        return true;
    }

    function unpauseToken() external onlyRole(PAUSE_ROLE) returns (bool) {
        _unpause();
        return true;
    }

    function mint(address _to, uint256 _value) external onlyRole(MINTER_ROLE) returns (bool) {
        _mint(_to, _value);
        return true;
    }

    function burn(address _to, uint256 _value) external onlyRole(BURNER_ROLE) returns (bool) {
        _burn(_to, _value);
        return true;
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual override {
        super._beforeTokenTransfer(from, to, amount);
        require(!paused(), "ERC20Pausable: token transfer while paused");
    }
}
