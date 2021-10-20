// SPDX-License-Identifier: MIT

pragma solidity 0.8.2;

import "@openzeppelin/contracts-upgradeable/utils/math/SafeCastUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract HLTHTokenV1 is  Initializable , ContextUpgradeable , AccessControlUpgradeable , PausableUpgradeable , ERC20Upgradeable , UUPSUpgradeable {
    using SafeCastUpgradeable for *;
    using SafeMathUpgradeable for uint256;
    using AddressUpgradeable for address;

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");

    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");

    function initialize() external initializer {
        __TagMoonERC20Upgradable_init( "HLTH Token" , "HLTH" );
    }

    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * The default value of {decimals} is 18. To select a different value for
     * {decimals} you should overload it.
     *
     * All two of these values are immutable: they can only be set once during
     * construction.
     */
    function __TagMoonERC20Upgradable_init(string memory name_, string memory symbol_ ) internal initializer {
        __Context_init_unchained();
        __AccessControl_init();
        __Pausable_init();
        __ERC20_init_unchained(name_, symbol_);
        __TagMoonERC20Upgradable_init_unchained();

        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);

        _setRoleAdmin(MINTER_ROLE, DEFAULT_ADMIN_ROLE);
        _setRoleAdmin(BURNER_ROLE, DEFAULT_ADMIN_ROLE);
        _setRoleAdmin(PAUSER_ROLE, DEFAULT_ADMIN_ROLE);
    }

    function __TagMoonERC20Upgradable_init_unchained() internal initializer {}

    function _authorizeUpgrade(address newImplementation) internal virtual override onlyRole(DEFAULT_ADMIN_ROLE) {}

    function pauseToken ( ) public virtual onlyRole(PAUSER_ROLE) returns ( bool ){
        _pause();
        return true;
    }

    function unpauseToken ( ) public virtual onlyRole(PAUSER_ROLE) returns ( bool ){
        _unpause();
        return true;
    }

    function mint ( address _to , uint256 _value ) public virtual onlyRole(MINTER_ROLE) returns ( bool ){
        _mint(_to , _value );
        return true;
    }

    function burn ( address _from , uint256 _value ) public virtual onlyRole(BURNER_ROLE) returns ( bool ){
        _burn( _from , _value );
        return true;
    }

    /**
     * @dev See {ERC20-_beforeTokenTransfer}.
     *
     * Requirements:
     *
     * - the contract must not be paused.
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual override {
        super._beforeTokenTransfer(from, to, amount);

        require(!paused(), "ERC20Pausable: token transfer while paused");
    }

}
