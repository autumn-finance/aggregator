// SPDX-License-Identifier: MIT

/*
 * This file is part of the Autumn Aggregator Smart Contract
 */

pragma solidity ^0.7.3;

import "../vendor/SafeMath.sol";
import "../vendor/SafeERC20.sol";

interface IProviderInformative {
    /// @notice the accepted token of the remote
    function tokenToDeposit() external view returns (address depositToken);

    /// @notice the rewarding token of the remote
    function tokenToReward() external view returns (address rewardToken);

    /// @notice the total balance that deposited to the remote
    function balance() external view returns (uint256 depositAmount);

    /// @notice the rewards that currently available from the remote
    function rewards() external view returns (uint256 rewardAmount);
}

interface IProvider is IProviderInformative {
    function IS_PROVIDER() external pure returns (bool);

    /// @notice to carry an update to the remote manually (redeposit, etc.)
    function update() external;

    /// @notice to deposit specific amount of deposit token to the remote
    function deposit(uint256 tokenAmount) external payable returns (uint256 actualAmount);

    /// @notice to withdraw specific amount of deposit token from the remote
    function withdraw(uint256 tokenAmount) external returns (uint256 actualAmount);

    /// @notice to withdraw all the balance from the remote
    function withdrawAll() external returns (uint256 actualAmount);

    /// @notice to harvest the available reward from the remote
    function harvest() external returns (uint256 rewardAmount);
}