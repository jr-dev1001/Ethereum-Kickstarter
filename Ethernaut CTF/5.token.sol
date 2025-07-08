// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

/*objective is to claim more than the coins you (by default player get 20)*/
contract Token {
    mapping(address => uint256) balances;
    uint256 public totalSupply;

    constructor(uint256 _initialSupply) public {
        balances[msg.sender] = totalSupply = _initialSupply;
    }

    // you can attack simple calling with the address that doesn't have any tokens
    // await contract.transfer('0x0000....0', 21)
    function transfer(address _to, uint256 _value) public returns (bool) {
        require(balances[msg.sender] - _value >= 0);
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        return true;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }
}