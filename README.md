### Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a Hardhat Ignition module that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat ignition deploy ./ignition/modules/Lock.js
```


### Steps of Development:
1. `npm init -y` , `pnpm i --save-dev hardhat` , `npx hardhat init` , `pnpm i @openzeppelin/contracts`
2. Creating the constructor, setting the owner, calling the mint function(OpenZeppelin)
3. Setting the capped supply(OpenZeppelin), setting the token to be burnable(OpenZeppelin)
4. Setting the block reward in the constructor as well keeping a function to set the block reward
5. Creating _mintMinerReward func and using the _update function for the block reward(instead of _beforeTokenTransfer func since new version of OpenZeppelin)
6. Creating a destroy func calling the selfdestruct func but that is deprecated and may create security issues so we switched to disabling the contract
7. Switching back to @openzeppelin/contracts@4.9.3 since OpenZeppelin v5.0 has some breaking changes which was causing issues, deleted the _update func and added the _beforeTokenTransfer func
8. `npx hardhat compile` , Copying the tests and testing them with -> `npx hardhat test`
9. Configuring the hardhat.config.js for the network, adding the sepolia network, `pnpm i dotenv`
10. Creating the deploy.js to deploy the contract, running -> `npx hardhat run scripts/deploy.js --network sepolia`
11. Deployed to sepolia, contract address -> 0x6043C6E96eA905DC93f51f168a40A4DBe9e77431
12. We can also deploy it to layer2 chain like polygon,etc. simply by changing the network in the hardhat.config.js



### ERC20 Standard:
Functions
- totalSupply()
- balanceOf(account)
- transfer(to, amount)
- allowance(owner, spender)
- approve(spender, amount)
- transferFrom(from, to, amount)


### Token Design:
- initial supply -> Send to owner - 70,000,000(70%)
- capped/ max supply -> 100,000,000
- minting strategy
- block reward
- burnable