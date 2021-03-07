// SPDX-License-Identifier: MIT

/*
 * This file is part of the Autumn Aggregator Smart Contract
 */

pragma solidity ^0.7.3;

interface IConvert {
    function from() external returns (address);
    function to() external returns (address);
    function convert(uint256 amount) external returns (uint256 got);
}