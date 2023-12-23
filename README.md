# Simultaneaoud Upgrades using Beacon Proxy Pattern

This is the companion repo for the article [Is it possible to create upgradeable Minimal Proxy Clone contracts?](https://blog.ignaciopastorsanchez.com/upgradeable-beacon-proxy)

It shows how you can apply a Factory Pattern to create multiple copies of a given contract, and upgrade all of that copies simulteneously using the Beacon Proxy pattern.

There is also an implementation using UUPS to show how this pattern is not feasible for simultaneous upgrades because the implementation address is stored in the Proxy storage.

You can see a basic POC of how upgrades work with the Beacon Proxy in the `test/BeaconproxyFactory.t.sol` file.

## Instructions.
Assuming you already have Rust and Foundry installed.

See the [Book of Foundry](https://book.getfoundry.sh/projects/working-on-an-existing-project.html) to learn more.

1. 
```bash
forge install
```
2. Compile the project
```bash
forge build
``` 
3. Run test suite
```bash
forge test
```

### Generate docs based on Natspec on files

```bash
forge doc
```

### Check test coverage 
```bash
forge coverage
```

### Run Foundry formater
```bash
forge fmt
``` 

## Get all functions selectors from a contract
```bash
forge inspect <YourContractName> methods
```

**Run Locally**

Open Anvil local node
```bash
anvil
```
Load .env variables 
in .env file->NO spaces between variable name and value, value with quotes. PRIVATE_KEY="blablabla"
```bash
source .env
```
Run on local node
```bash
forge script script/DeployBeacon.s.sol:Deploy --fork-url http://localhost:8545  --private-key $PRIVATE_KEY_ANVIL_0 --broadcast 
```

**Deploy to Sepolia**

Load .env variables 
in .env file->NO spaces between variable name and value, value with quotes. PRIVATE_KEY="blablabla"
```bash
source .env
```

Deploy to Sepolia and verify
```bash
forge script script/DeployBeacon.s.sol:Deploy --rpc-url $SEPOLIA_KEY  --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $ETHERSCAN_KEY -vvvv
```
# foundry-template
# foundry-template
