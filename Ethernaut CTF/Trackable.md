### [Level Name]
🧠 Vulnerability Concept: </br>
🛠️ Exploit Mechanism: </br>
🔁 Real-World Example: </br>
✍️ My Attack Summary (in 2-3 steps): </br>
📦 Solidity Snippet I learned: </br>

---
### [Level Name - 0.Hello]

☢️ Vulnerability Concept:
No actual vulnerability — this level is for setup, interaction, and basic Solidity understanding. It's about exploring and understanding the Ethernaut environment, ABI, and on-chain data.

🛠️ Exploit Mechanism:
Interact with the contract using the console to:
1. Navigate function calls step-by-step (info → info1 → info2 → info42 → method7123949)
2. Read the private password from storage slot 0
3. Pass the password to `authenticate()` to clear the level

🔁 Real-World Example:
Understanding that private variables in Solidity are not really hidden — they're stored on-chain and can be read by anyone. Also introduces contract introspection using web3 or ethers.js.

✍️ My Attack Summary (in 2-3 steps):
1. Used `await contract.info()` and followed function hints
2. Read `password` from slot 0 using `web3.eth.getStorageAt(instance.address, 0)`
3. Called `authenticate(password)` to complete the level

📦 Solidity Snippet I learned:
```solidity
function authenticate(string memory passkey) public {
    if (keccak256(abi.encodePacked(passkey)) == keccak256(abi.encodePacked(password))) {
        cleared = true;
    }
}
```
---
### [Level Name - 1.Fallback]

☢️ Vulnerability Concept:
Misused `receive()` fallback function allows ownership transfer when certain conditions are met. Ownership logic is unintentionally duplicated in the fallback, creating a secondary path to become owner.

🛠️ Exploit Mechanism:
1. Make a small contribution using `contribute()` (less than 0.001 ETH)
2. Send ETH directly to the contract to trigger the `receive()` function
3. This changes the `owner` to `msg.sender` if contribution was > 0
4. Call `withdraw()` to drain the contract balance

🔁 Real-World Example:
Poorly designed fallback functions in contracts can become unauthorized entry points. This mimics real DeFi attacks where fallback/receive is over-permissive or improperly guarded.

✍️ My Attack Summary (in 2-3 steps):
1. Called `contribute()` with a tiny amount to satisfy `contributions[msg.sender] > 0`
2. Sent ETH directly to the contract address (triggered `receive()`), became `owner`
3. Called `withdraw()` and drained the contract balance

📦 Solidity Snippet I learned:
```solidity
receive() external payable {
    require(msg.value > 0 && contributions[msg.sender] > 0);
    owner = msg.sender;
}
```
🧠 This showed me how fallback functions can be dangerous when they change critical contract state like ownership.
---
### [Level Name - 2.Fallout]

☢️ Vulnerability Concept:
Incorrect constructor declaration in older Solidity versions — `Fal1out()` is just a public function, not a constructor, due to a typo. This allows anyone to call it after deployment and set themselves as the contract owner.

🛠️ Exploit Mechanism:
1. Identify that `Fal1out()` is not a constructor (misspelled, lowercase `L` and digit `1`)
2. Call `Fal1out()` directly — it sets `owner = msg.sender`
3. Now that you're owner, you can call `collectAllocations()` to drain the contract

🔁 Real-World Example:
Before Solidity 0.4.22 introduced the `constructor` keyword, constructor functions relied on matching the contract name exactly. Typos allowed malicious actors to claim ownership post-deployment — seen in older DeFi codebases.

✍️ My Attack Summary (in 2-3 steps):
1. Called the misnamed `Fal1out()` function directly to become owner
2. Verified ownership with the `owner()` public getter
3. Called `collectAllocations()` to transfer contract balance to myself

📦 Solidity Snippet I learned:
```solidity
function Fal1out() public payable {
    owner = msg.sender;
    allocations[owner] = msg.value;
}
```
---

---

### [Level Name - 4.Telephone]

☢️ Vulnerability Concept:
Improper use of `tx.origin` for ownership authentication — leads to logic bypass when function is called via contract.

🛠️ Exploit Mechanism:
Call `changeOwner()` through an attacker contract so that `msg.sender != tx.origin`, satisfying the contract's condition and allowing ownership takeover.

🔁 Real-World Example:
Phishing attacks where malicious contracts exploit `tx.origin` checks to perform unauthorized actions on behalf of unsuspecting users (e.g., Parity Multisig vulnerability pattern).

✍️ My Attack Summary (in 2-3 steps):
1. Deploy a contract that calls `changeOwner(tx.origin)` on the target.
2. Call that contract from your EOA (externally owned account).
3. Since `msg.sender` (contract) ≠ `tx.origin` (EOA), condition passes and owner becomes EOA.

📦 Solidity Snippet I learned:
```solidity
function attack() external {
    telephone.changeOwner(tx.origin);
}
```
---
### [Level Name - 5.Token]


🧠 Vulnerability Concept:
Integer underflow — in Solidity <0.8.0, subtracting a larger number from a smaller one wraps around to a huge value. This breaks balance checks and allows attackers to gain unearned tokens.

🛠️ Exploit Mechanism:
1. The contract checks `require(balances[msg.sender] - _value >= 0)`  
   This looks safe, but in Solidity 0.6.0, underflow wraps to max `uint256`
2. Call `transfer()` with `_value > balance` (e.g., transfer 21 tokens with only 20 in balance)
3. `balances[msg.sender]` underflows → becomes huge number
4. This lets you send massive value and claim balance you didn’t have

🔁 Real-World Example:
Before Solidity 0.8.x added automatic overflow/underflow protection, many DeFi hacks abused this behavior. For example, the 2017 `Parity Wallet` vulnerability was partly caused by unsafe math operations.

✍️ My Attack Summary (in 2-3 steps):
1. I started with 20 tokens (default)
2. Called `transfer(<any address>, 21)` — underflow bypassed the balance check
3. `balances[msg.sender]` became huge — effectively giving me infinite tokens

📦 Solidity Snippet I learned:
```solidity
require(balances[msg.sender] - _value >= 0); // looks safe, but unsafe in Solidity <0.8.0
balances[msg.sender] -= _value;
balances[_to] += _value;
```
---
