// SPDX-License-Identifier: MIT

/*
 * This file is part of the Autumn Aggregator Smart Contract
 */

pragma solidity ^0.7.3;

import "./vendor/SafeERC20.sol";
import "./vendor/Operator.sol";

abstract contract FeeManager is Operator {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    constructor() Operator() {}

    uint256 private constant FEE_DENOMINATOR = 1e8;

    mapping (string => uint256) public fees;

    mapping (address => uint256) public allocatedFees;
    mapping (address => uint256) public feeTransferHousehold;

    address public feeRecipient = address(0);

    /// @dev charge fee on the amount and allocated for the associated token (and transfer if exceeds household)
    function chargeFeeWith(string memory name, address token, uint256 amount) internal returns (uint256 afterAmount) {
        uint256 fee = fees[name];
        if (fee == 0) {
            return amount;
        }

        uint256 fee_ = amount.mul(fee).div(FEE_DENOMINATOR);

        uint256 allocated = allocatedFees[token] = allocatedFees[token].add(fee_);
        if (allocated > feeTransferHousehold[token] && feeRecipient != address(0)) {
            IERC20(token).safeTransfer(feeRecipient, allocated);
            allocatedFees[token] = 0;
        }

        return amount.sub(fee_);
    }

    // Governance

    function setFeeFor(string memory name, uint256 fee) onlyOperator() external {
        fees[name] = fee;
    }

    function setFeeRecipient(address recipient) onlyOperator() external {
        feeRecipient = recipient;
    }

    function setFeeTransferHousehold(address token, uint256 household) onlyOperator() external {
        feeTransferHousehold[token] = household;
    }

    function claimFee(address token, address to) onlyOperator() external {
        require(allocatedFees[token] != 0, "SimpleVault: no allocated fee yet");
        IERC20(token).safeTransfer(to, allocatedFees[token]);
        allocatedFees[token] = 0;
    }
}