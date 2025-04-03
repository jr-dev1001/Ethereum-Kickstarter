// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {SimpleStorage} from "./SimpleStorage.sol";

contract SimpleStorageFactory{
    //uint256 public favoroiteNumber
    // type visibility name
    SimpleStorage[] public listOfSimpleStorageContracts;

    function createSimpleStorageContract() public{
        SimpleStorage newSimpleStorageContract = new SimpleStorage();
        listOfSimpleStorageContracts.push(newSimpleStorageContract);
    }
    // calling function of other contracts
    function sfStore(uint256 _simpleStorageIndex, uint256 _newSimpleStorageNumber) public{
        // we always require an address and ABI (Application Binary Interface tells how it can interact with contracts).
        SimpleStorage mySimpleStorage = listOfSimpleStorageContracts[_simpleStorageIndex];
        mySimpleStorage.store(_newSimpleStorageNumber);
    }

    function sfGet(uint256 _simpleStorageIndex)  public view returns (uint256){
        // SimpleStorage mySimpleStorage = listOfSimpleStorageContracts[_simpleStorageIndex];
        return listOfSimpleStorageContracts[_simpleStorageIndex].retrieve();
    }
}