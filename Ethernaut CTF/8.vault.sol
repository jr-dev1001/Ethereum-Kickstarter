// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Vault {
    bool public locked; // slot 0
    bytes32 private password; // slot 1

    constructor(bytes32 _password) {
        locked = true;
        password = _password;
    }

    function unlock(bytes32 _password) public {
        if (password == _password) {
            locked = false;
        }
    }
}


/* as we can see that storage variables are still publicly accessible,
so here we can simply access them by calling `web3.eth.getStorageAt('instance address', storage_slot_numb,console.log);`  */


