// SPDX-License-Identifier: MIT

/*
 * This file is part of the Autumn Aggregator Smart Contract
 */

pragma solidity ^0.7.3;

import "../vendor/Operator.sol";
import "../vendor/SafeMath.sol";
import "../vendor/SafeERC20Wrapper.sol";

import { IProvider } from "./IProvider.sol";

abstract contract AbstractProvider is IProvider, SafeERC20Wrapper, Operator {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    bool public override constant IS_PROVIDER = true;

    // Viewers

    function tokenToDeposit() public override virtual view returns (address tokenAddress);

    function tokenToReward() public override virtual view returns (address tokenAddress);

    function balance() public override virtual view returns (uint256 depositTokenAmount);

    function rewards() public override virtual view returns (uint256 rewardTokenAmount);

    // Externals

    function update() public override virtual;

    function deposit(uint256 amount) onlyContractOperator() external override payable returns (uint256 actualAmount) {
        require(amount != 0, "AbstractProvider: cannot deposit zero");
        amount = safeReceiveERC20(tokenToDeposit(), _msgSender(), amount);
        if (amount != 0) {
            _deposit(amount);
        }
        return amount;
    }

    function withdrawAll() onlyContractOperator() external override returns (uint256 actualAmount) {
        return withdraw(balance());
    }

    function withdraw(uint256 amount) onlyContractOperator() public override returns (uint256 actualAmount) {
        require(amount != 0, "AbstractProvider: cannot withdraw zero");
        amount = _safeWithdraw(amount);
        if (amount != 0) {
            IERC20(tokenToDeposit()).safeTransfer(_msgSender(), amount);
        }
        return amount;
    }

    function harvest() onlyContractOperator() external override returns (uint256 reward) {
        reward = _safeHarvest();
        if (reward != 0) {
            IERC20(tokenToReward()).safeTransfer(_msgSender(), reward);
        }
        return reward;
    }

    // Internals

    function _deposit(uint256 tokenAmount) internal virtual;

    function _withdraw(uint256 tokenAmount) internal virtual;

    function _harvest() internal virtual;

    // Safe Wrappers

    function _safeWithdraw(uint256 amount) private returns (uint256 actualAmount) {
        IERC20 d = IERC20(tokenToDeposit());
        uint256 before = d.balanceOf(address(this));
        _withdraw(amount);
        return d.balanceOf(address(this)).sub(before);
    }

    function _safeHarvest() private returns (uint256 actualAmount) {
        IERC20 r = IERC20(tokenToReward());
        uint256 before = r.balanceOf(address(this));
        _harvest();
        return r.balanceOf(address(this)).sub(before);
    }
}