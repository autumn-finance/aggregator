// SPDX-License-Identifier: MIT

/*
 * This file is part of the Autumn Aggregator Smart Contract
 */

pragma solidity ^0.7.3;

interface IConverter {
    function proposeConvert(
        address from,
        address to,
        uint256 amount
    ) external payable returns (
        bool success,
        uint256 got
    );
}