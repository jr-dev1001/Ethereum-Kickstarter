// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {SimpleStorage} from "./SimpleStorage.sol";

contract AddFive is SimpleStorage {
    //visual override
    function store(uint256 _newNUmber) public override {
        MyfavoriteNumber = _newNUmber+5;
    }
}