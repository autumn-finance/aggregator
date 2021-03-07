// SPDX-License-Identifier: MIT

/*
 * This file is part of the Autumn Aggregator Smart Contract
 */

pragma solidity ^0.7.3;

import "./SafeERC20.sol";

abstract contract SafeERC20Wrapper {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    function safeReceiveERC20(address token, address from, uint256 amount) internal returns (uint256 actualAmount) {
        IERC20 t = IERC20(token);
        uint256 before = t.balanceOf(address(this));
        t.safeTransferFrom(from, address(this), amount);
        return t.balanceOf(address(this)).sub(before);
    }
}