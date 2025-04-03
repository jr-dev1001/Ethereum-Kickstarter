### Installing web3 
- Run `npm i web3` in your terminal to install web3.js
- Or you can simply download the minified .js file from [github](https://github.com/web3/web3.js/blob/1.x/dist/web3.min.js) and include it in your project.

---
> Note: All the code examples we're using in this lesson are using version 1.0 of Web3.js, which uses promises instead of callbacks.
---
### Notes (souce CryptoZombies)
- Ethereum nodes only speak a language called JSON-RPC, which isn't very human-readable.To overcome web3 make a way for us to interact with javascript interface.
- Remember, Ethereum is made up of nodes that all share a copy of the same data. Setting a Web3 Provider in Web3.js tells our code which node we should be talking to handle our reads and writes. It's kind of like setting the URL of the remote web server for your API calls in a traditional web app.
- `Infura` is a service that maintains a set of Ethereum nodes with a caching layer for fast reads, which you can access for free through their API. Using Infura as a provider, you can reliably send and receive messages to/from the Ethereum blockchain without needing to set up and maintain your own node.
- `Metamask` uses Infura's servers under the hood as a web3 provider, just like we did above — but it also gives the user the option to choose their own web3 provider. So by using Metamask's web3 provider, you're giving the user a choice, and it's one less thing you have to worry about in your app.
- *`Web3.js` will need 2 things to talk to your contract: its `address` and its `ABI`*.
- - *`ABI` stands for Application Binary Interface. Basically it's a representation of your contracts' methods in JSON format that tells Web3.js how to format function calls in a way your contract will understand.*
- Web3.js has two methods we will use to call functions on our contract: `call` and `send`.
- - `call` is used for `view` and `pure` functions.
- - `send` will create a transaction and change data on the blockchain. You'll need to use `send` for any functions that aren't `view` or `pure`.
- sending a transaction requires a from address of who's calling the function (which becomes msg.sender in your Solidity code).
- *Saving data to the blockchain is one of the most expensive operations in Solidity. But using events is much much cheaper in terms of gas.*

---
### What we do here.

#### 1: Intro to Web3
- We've created a shell of an HTML project file for you, index.html. Let's assume we have a copy of web3.min.js in the same folder as index.html.
- Go ahead and copy/paste the script tag above into our project so we can use web3.js

#### 2: Web3 providers
- We've created some empty script tags before the closing </body> tag in our HTML file. We can write our JavaScript code for this lesson here.
- Go ahead and copy/paste the template code from above for detecting Metamask. It's the block that starts with window.addEventListener.

#### 3: Talking to contracts
1. In the <head> of our document, include another script tag for cryptozombies_abi.js so we can import the ABI definition into our project.
2. At the beginning of our <script> tag in the <body>, declare a var named `cryptoZombies`, but don't set it equal to anything. Later we'll use this variable to store our instantiated contract.
3. Next, create a function named `startApp()`. We'll fill in the body in the next 2 steps.
4. The first thing `startApp()` should do is declare a var named `cryptoZombiesAddress` and set it equal to the string "YOUR_CONTRACT_ADDRESS" (this is the address of the `CryptoZombies` contract on mainnet).
5. Lastly, let's instantiate our contract. Set cryptoZombies equal to a new web3js.eth.Contract like we did in the example code above. (Using `cryptoZombiesABI`, which gets imported with our script tag, and `cryptoZombiesAddress` from above).

#### 4: Calling Contract Functions
1. We've gone ahead and copied `getZombieDetails` into the code for you.
2. Let's create a similar function for `zombieToOwner`. If you recall from ZombieFactory.sol, we had a mapping that looked like:
```solidity
mapping (uint => address) public zombieToOwner;
```
3. Define a JavaScript function called `zombieToOwner`. Similar to `getZombieDetails` above, it will take an `id` as a parameter, and will return a Web3.js call to `zombieToOwner` on our contract.

4. Below that, create a third function for `getZombiesByOwner`. If you recall from ZombieHelper.sol, the function definition looked like this:

```solidity
function getZombiesByOwner(address _owner)
```
5. Our function `getZombiesByOwner` will take owner as a parameter, and return a Web3.js `call` to `getZombiesByOwner`.

#### 5: Metamask & Accounts
1. Let's make it so our app will display the user's zombie army when the page first loads, and monitor the active account in MetaMask to refresh the display if it changes.

2. Declare a var named `userAccount`, but don't assign it to anything.

3. At the end of startApp(), copy/paste the boilerplate `accountInterval` code from above

4. Replace the line `updateInterface();` with a call to `getZombiesByOwner`, and pass it userAccount

5. Chain a then statement after `getZombiesByOwner` and pass the result to a function named displayZombies. (The syntax is: `.then(displayZombies);`).
We don't have a function called displayZombies yet, but we'll implement it in the next chapter.

#### 6: Displaying zombie Army
1. We created an empty `displayZombies` function for you. Let's fill it in.
2. The first thing we'll want to do is empty the `#zombies` div. In JQuery, you can do this with `$("#zombies").empty();`.
3. Next, we'll want to loop through all the ids, using a for loop: `for (const id of ids) {}`
4. Inside the for loop, copy/paste the code block above that called `getZombieDetails(id)` for each id and then used `$("#zombies").append(...)` to add it to our HTML.

#### 7: Sending Transactions
We've added a div with ID txStatus — this way we can use this div to update the user with messages with the status of our transactions.

1. Below displayZombies, copy / paste the code from createRandomZombie above.
Let's implement another function: feedOnKitty.

2. The logic for calling feedOnKitty will be almost identical — we'll send a transaction that calls the function, and a successful transaction results in a new zombie being created for us, so we'll want to redraw the UI after it's successful.
Make a copy of createRandomZombie right below it, but make the following changes:
    a) Call the 2nd function `feedOnKitty`, which takes 2 arguments: `zombieId` and `kittyId`
    b) The `#txStatus` text should update to: `"Eating a kitty. This may take a while..."`
    c) Make it call `feedOnKitty` on our contract, and pass the same 2 arguments
    d) The success message on `#txStatus` should read: `"Ate a kitty and spawned a new Zombie!"`

#### 8: Call Payable Functions
Let's add a levelUp function below `feedOnKitty`. The code will be very similar to feedOnKitty, but:
1. The function will take 1 parameter, `zombieId`
2. Pre-transaction, it should display the `txStatus` text `"Leveling up your zombie..."`
3. When it calls levelUp on the contract, it should send "0.001" ETH converted toWei, as in the example above
4. Upon success it should display the text `"Power overwhelming! Zombie successfully leveled up"`
5. We don't need to redraw the UI by querying our smart contract with `getZombiesByOwner` — because in this case we know the only thing that's changed is the one zombie's level.

#### 9: Subsccribing events
Let's add some code to listen for the Transfer event, and update our app's UI if the current user receives a new zombie. We'll need to add this code at the end of the startApp function, to make sure the cryptoZombies contract has been initialized before adding an event listener.

1. At the end of startApp(), copy/paste the code block above listening for `cryptoZombies.events.Transfer`
2. For the line to update the UI, use `getZombiesByOwner(userAccount).then(displayZombies)`;

#### 10: Wrapping it up

For complete Implementation complete the below steps :

1. Implementing functions for attack, changeName, changeDna, and the ERC721 functions transfer, ownerOf, balanceOf, etc. The implementation of these functions would be identical to all the other send transactions we covered.

2. Implementing an "admin page" where you can execute setKittyContractAddress, setLevelUpFee, and withdraw. Again, there's no special logic on the front-end here — these implementations would be identical to the functions we've already covered. You would just have to make sure you called them from the same Ethereum address that deployed the contract, since they have the onlyOwner modifier.

3. There are a few different views in the app we would want to implement:

    a. An individual zombie page, where you can view info about a specific zombie with a permalink to it. This page would render the zombie's appearance, show its name, its owner (with a link to the user's profile page), its win/loss count, its battle history, etc.

    b. A user page, where you could view a user's zombie army with a permalink. You would be able to click on an individual zombie to view its page, and also click on a zombie to attack it if you're logged into MetaMask and have an army.

    c. A homepage, which is a variation of the user page that shows the current user's zombie army. (This is the page we started implementing in index.html).

4. Some method in the UI that allows the user to feed on CryptoKitties. We could have a button by each zombie on the homepage that says "Feed Me", then a text box that prompted the user to enter a kitty's ID (or a URL to that kitty, e.g. https://www.cryptokitties.co/kitty/578397). This would then trigger our function feedOnKitty.

5. Some method in the UI for the user to attack another user's zombie.

    One way to implement this would be when the user was browsing another user's page, there could be a button that said "Attack This Zombie". When the user clicked it, it would pop up a modal that contains the current user's zombie army and prompt them "Which zombie would you like to attack with?"

    The user's homepage could also have a button by each of their zombies that said "Attack a Zombie". When they clicked it, it could pop up a modal with a search field where they could type in a zombie's ID to search for it. Or an option that said "Attack Random Zombie", which would search a random number for them.

    We would also want to grey out the user's zombies whose cooldown period had not yet passed, so the UI could indicate to the user that they can't yet attack with that zombie, and how long they will have to wait.

6. The user's homepage would also have options by each zombie to change name, change DNA, and level up (for a fee). Options would be greyed out if the user wasn't yet high enough level.

7. For new users, we should display a welcome message with a prompt to create the first zombie in their army, which calls createRandomZombie().

8. We'd probably want to add an Attack event to our smart contract with the user's address as an indexed property, as discussed in the last chapter. This would allow us to build real-time notifications — we could show the user a popup alert when one of their zombies was attacked, so they could view the user/zombie who attacked them and retaliate.

9. We would probably also want to implement some sort of front-end caching layer so we aren't always slamming Infura with requests for the same data. (Our current implementation of displayZombies calls getZombieDetails for every single zombie every time we refresh the interface — but realistically we only need to call this for the new zombie that's been added to our army).

10. A real-time chat room so you could trash talk other players as you crush their zombie army? Yes plz.