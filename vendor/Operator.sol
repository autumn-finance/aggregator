// SPDX-License-Identifier: MIT

pragma solidity ^0.7.3;

/*
 * This file is part of the Autumn Aggregator Smart Contract
 */

import "./Address.sol";
import "./Ownable.sol";

abstract contract Operator is Ownable {
    using Address for address;

    mapping (address => bool) public operators;

    modifier onlyOperator() {
        require(operators[_msgSender()] || _msgSender() == owner(), "Operator: caller must be operator");
        _;
    }

    modifier onlyContractOperator() {
        require(address(_msgSender()).isContract(), "Operator: caller must be contract");
        require(operators[_msgSender()] || _msgSender() == owner(), "Operator: caller must be operator");
        _;
    }

    function setOperatorPermission(address operator, bool eligible) onlyOwner() external {
        operators[operator] = eligible;
        emit OperatorPermissionUpdated(operator, eligible);
    }

    event OperatorPermissionUpdated(address operator, bool eligible);
}