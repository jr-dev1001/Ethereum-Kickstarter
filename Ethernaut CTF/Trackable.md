### [Level Name]
🧠 Vulnerability Concept: </br>
🛠️ Exploit Mechanism: </br>
🔁 Real-World Example: </br>
✍️ My Attack Summary (in 2-3 steps): </br>
📦 Solidity Snippet I learned: </br>

---
### [Level Name - 0.Hello]

🧠 Vulnerability Concept:
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

---

### [Level Name - 4.Telephone]

🧠 Vulnerability Concept:
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
