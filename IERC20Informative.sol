// SPDX-License-Identifier: MIT

/*
 * This file is part of the Autumn Aggregator Smart Contract
 */

pragma solidity ^0.7.3;

/**
 * @dev Subset of the ERC20 standard Interface to provide information.
 */
interface IERC20Informative {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);
}