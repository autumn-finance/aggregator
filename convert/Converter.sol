// SPDX-License-Identifier: MIT

/*
 * This file is part of the Autumn Aggregator Smart Contract
 */

pragma solidity ^0.7.3;

import "../vendor/Rescuable.sol";
import "../vendor/SafeERC20Wrapper.sol";

import { IConvert } from "./IConvert.sol";
import { IConverter } from "./IConverter.sol";

contract Converter is IConverter, SafeERC20Wrapper, Rescuable {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    mapping (address /* from */ => mapping (address /* to */ => address)) public converts;

    function setConvert(
        address from,
        address to,
        address convert
    )
    onlyOwner()
    external {
        require(from != address(0), "addConvert: from is invalid");
        require(to != address(0), "addConvert: to is invalid");
        require(convert != address(0), "addConvert: convert is invalid");

        IConvert convert_ = IConvert(convert);
        require(convert_.from() == from, "addConvert: inconsistent from");
        require(convert_.to() == to, "addConvert: inconsistent to");
        converts[from][to] = convert;
    }

    function delConvert(
        address from,
        address to
    )
    onlyOwner()
    external {
        delete converts[from][to];
    }

    function proposeConvert(
        address from,
        address to,
        uint256 amount
    )
    external
    override
    payable
    returns (
        bool success,
        uint256 got
    ) {
        require(amount != 0, "Converter: cannot convert zero");
        address convert_ = converts[from][to];
        if (convert_ == address(0)) {
            return (false, 0);
        }

        amount = safeReceiveERC20(from, _msgSender(), amount);
        IERC20(from).safeIncreaseAllowance(convert_, amount);
        amount = _safeConvert(convert_, from, amount);
        IERC20(to).safeTransfer(_msgSender(), amount); // send back
        return (true, amount);
    }

    function _safeConvert(address convert, address to, uint256 amount) private returns (uint256 actualAmount) {
        IERC20 t = IERC20(to);
        uint256 before = t.balanceOf(address(this));
        IConvert(convert).convert(amount);
        return t.balanceOf(address(this)).sub(before);
    }
}