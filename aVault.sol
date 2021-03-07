// SPDX-License-Identifier: MIT

/*
 * This file is part of the Autumn Aggregator Smart Contract
 */

pragma solidity ^0.7.3;

import { IERC20Informative } from "./IERC20Informative.sol";

interface aVault is IERC20Informative {
    /// @notice returns the token to deposit
    function pool() external view returns (address);

    /// @notice the available reward of the user
    function earned(address user, address token) external view returns (uint256);

    /// @notice manually carries an update to the vault (update reward, etc.)
    function update() external;

    /// @notice claims available personal rewards from the vault
    function harvest() external;

    /// @notice deposit amount of the token to the vault
    function deposit(uint256 amount) external payable returns (uint256 actualAmount);

    /// @notice withdraw amount of the token to the vault
    function withdraw(uint256 amount) external returns (uint256 actualAmount);
}