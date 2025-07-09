### [Level Name]
🧠 Vulnerability Concept: </br>
🛠️ Exploit Mechanism: </br>
🔁 Real-World Example: </br>
✍️ My Attack Summary (in 2-3 steps): </br>
📦 Solidity Snippet I learned: </br>

---

### [Level Name - Telephone]

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
