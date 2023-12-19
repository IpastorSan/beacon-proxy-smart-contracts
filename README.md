# Foundry Template

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
forge script script/DeployLocal.s.sol:Deploy --fork-url http://localhost:8545  --private-key $PRIVATE_KEY_ANVIL_0 --broadcast 
```

**Deploy to Sepolia**

Load .env variables 
in .env file->NO spaces between variable name and value, value with quotes. PRIVATE_KEY="blablabla"
```bash
source .env
```

Deploy to Sepolia and verify
```bash
forge script script/DeployTestnet.s.sol:Deploy --rpc-url $SEPOLIA_KEY  --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $ETHERSCAN_KEY -vvvv
```
# foundry-template
# foundry-template
