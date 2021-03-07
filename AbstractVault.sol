// SPDX-License-Identifier: MIT

/*
 * This file is part of the Autumn Aggregator Smart Contract
 */

pragma solidity ^0.7.3;

import "./vendor/Context.sol";
import "./vendor/SafeERC20Wrapper.sol";

import { aVault } from "./aVault.sol";

abstract contract AbstractVault is aVault, SafeERC20Wrapper, Context {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    bool constant public IS_VAULT = true;

    address public override pool;

    // Deposit

    function deposit(uint256 amount) external override payable returns (uint256 actualAmount) {
        require(amount != 0, "AbstractVault: cannot deposit zero");
        uint256 expectedAmount = amount; // store for event reporting

        // call before event
        amount = beforeTokenTransferIn(amount);

        // transfer in token
        amount = safeReceiveERC20(pool, _msgSender(), amount);

        // call after event
        afterTokenTransferredIn(amount);

        emit Deposit(expectedAmount, amount);
        return amount;
    }

    function beforeTokenTransferIn(uint256 amount) internal virtual returns (uint256 actualAmount) {
        return amount;
    }

    function afterTokenTransferredIn(uint256 amount) internal virtual {}

    // Withdraw

    function withdraw(uint256 amount) external override returns (uint256 actualAmount) {
        require(amount != 0, "AbstractVault: cannot withdraw zero");
        uint256 expectedAmount = amount; // store for event reporting

        // call before event
        amount = beforeTokenTransferOut(amount);

        // transfer out the token
        IERC20(pool).safeTransfer(_msgSender(), amount);

        // call after event
        afterTokenTransferredOut(amount);

        emit Withdraw(expectedAmount, amount);
        return amount;
    }

    function beforeTokenTransferOut(uint256 amount) internal virtual returns (uint256 actualAmount) {
        return amount;
    }

    function afterTokenTransferredOut(uint256 amount) internal virtual {}

    // Events

    event Deposit(uint256 expectedAmount, uint256 actualAmount);
    event Withdraw(uint256 expectedAmount, uint256 actualAmount);
}