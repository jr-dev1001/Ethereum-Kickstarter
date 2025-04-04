// SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

contract Calculator {
    event Log(string fun, uint256 gas);
    function addition (uint _a, uint _b) public pure returns (uint){
        return _a+_b;
    }
    function subtraction (uint _a, uint _b) public pure returns (uint){
        return _a-_b;
    }

    function multiplication (uint _a, uint _b) public pure returns (uint){
        return _a*_b;
    }

    function division (uint _a, uint _b) public pure zeroDivision(_a,_b) returns (uint){
        return  _a/_b;
    }

    function CalculateAll (uint _a, uint _b) public pure returns(uint, uint, uint, uint) {
        return (addition(_a, _b), subtraction(_a, _b), multiplication(_a, _b), division(_a, _b));
    }

    modifier zeroDivision(uint _a, uint _b){
        require(_b!=0, "Zero Division ERR occured");
        _;
    }

    receive() external payable{
        emit Log("This is for revising receive",gasleft());
    }
    fallback() external payable{
        emit Log("This is for revising fallback",gasleft());
    }
}