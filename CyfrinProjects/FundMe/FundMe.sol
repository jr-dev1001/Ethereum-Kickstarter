//Get funds from users
// wothdraw funds

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {priceConvertor} from "./PriceConvertor.sol";

error NotOwner();

// import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract Fundme {
    using priceConvertor for uint256;
    uint256 public constant minimumUsd = 5e18;
    
    address[] public funders;
    mapping (address funder => uint256 amountFunded) public addressToAmountFunded;
    address public immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }
    function fund() public payable {
        require(msg.value.getConversionRate()>= minimumUsd, "You need to spend more ETH!"); //1e18 = 1 ETH = 1*10**18
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] +=  msg.value;
    }

    function withdraw() public onlyOwner{
        for(uint256 funderIndex = 0 ; funderIndex < funders.length; funderIndex ++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0; //decreasing amount funded by withdraw value
        }
        //reset the array 
        funders = new address[](0);
        //actually withdraw the funds

        // transfer - reverts the transaction and send doesn't but returns a boolean
        //msg.sender of type address
        //payable(msg.sender) = payable address
        payable(msg.sender).transfer(address(this).balance);

        //send
        bool sendSuccess = payable(msg.sender).send(address(this).balance);
        require(sendSuccess,"Withdraw send failed");
        //call
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess,"Withdrawal call Failed!");
    }

    modifier onlyOwner() { //modifier must be declared
        // require (msg.sender == i_owner, "Only owner can perform this action");
        if(msg.sender != i_owner){ revert NotOwner();}
        _;  //this is the code of what should be done in this block
    }

    //what happends if someone sends this contract ETH without calling the Fund function?
    //without data
    receive() external payable { fund(); }
    //with data
    fallback() external payable { fund(); }
   
}



