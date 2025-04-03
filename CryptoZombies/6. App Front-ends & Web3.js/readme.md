### Installing web3 
- Run `npm i web3` in your terminal to install web3.js
- Or you can simply download the minified .js file from [github](https://github.com/web3/web3.js/blob/1.x/dist/web3.min.js) and include it in your project.

---
### Notes (souce CryptoZombies)
- Ethereum nodes only speak a language called JSON-RPC, which isn't very human-readable.To overcome web3 make a way for us to interact with javascript interface.
- Remember, Ethereum is made up of nodes that all share a copy of the same data. Setting a Web3 Provider in Web3.js tells our code which node we should be talking to handle our reads and writes. It's kind of like setting the URL of the remote web server for your API calls in a traditional web app.
- `Infura` is a service that maintains a set of Ethereum nodes with a caching layer for fast reads, which you can access for free through their API. Using Infura as a provider, you can reliably send and receive messages to/from the Ethereum blockchain without needing to set up and maintain your own node.
- `Metamask` uses Infura's servers under the hood as a web3 provider, just like we did above — but it also gives the user the option to choose their own web3 provider. So by using Metamask's web3 provider, you're giving the user a choice, and it's one less thing you have to worry about in your app.
- *`Web3.js` will need 2 things to talk to your contract: its `address` and its `ABI`*.
- - *`ABI` stands for Application Binary Interface. Basically it's a representation of your contracts' methods in JSON format that tells Web3.js how to format function calls in a way your contract will understand.*
- Web3.js has two methods we will use to call functions on our contract: `call` and `send` .
---
### What we do here.

#### 1:
- We've created a shell of an HTML project file for you, index.html. Let's assume we have a copy of web3.min.js in the same folder as index.html.

- Go ahead and copy/paste the script tag above into our project so we can use web3.js

#### 2:
- We've created some empty script tags before the closing </body> tag in our HTML file. We can write our JavaScript code for this lesson here.

- Go ahead and copy/paste the template code from above for detecting Metamask. It's the block that starts with window.addEventListener.

#### 3:
1. In the <head> of our document, include another script tag for cryptozombies_abi.js so we can import the ABI definition into our project.
2. At the beginning of our <script> tag in the <body>, declare a var named cryptoZombies, but don't set it equal to anything. Later we'll use this variable to store our instantiated contract.
3. Next, create a function named startApp(). We'll fill in the body in the next 2 steps.
4. The first thing startApp() should do is declare a var named cryptoZombiesAddress and set it equal to the string "YOUR_CONTRACT_ADDRESS" (this is the address of the CryptoZombies contract on mainnet).
5. Lastly, let's instantiate our contract. Set cryptoZombies equal to a new web3js.eth.Contract like we did in the example code above. (Using cryptoZombiesABI, which gets imported with our script tag, and cryptoZombiesAddress from above).

#### 4:
#### 5:
#### 6:
#### 7:
#### 8:
#### 9:
#### 10: