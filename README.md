## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

#### Mainnets

```shell
$ forge script script/DeployMainnetFaucet.s.sol:DeployMainnetFaucet --rpc-url $RPC_URL --broadcast -vvvv
```

Replace $RPC_URL with one of the following to deploy there:

- apechain [CURRENTLY UNAVAILABLE] 
- arbitrum
- base
- celo
- morph
- rootstock
- scroll
- zircuit

### Testnets

```shell
$ forge script script/DeployTestnetFaucet.s.sol:DeployTestnetFaucet --rpc-url $RPC_URL --broadcast -vvvv
```

- apechainTest
- arbitrumTest
- baseTest
- celoTest
- morphTest
- rootstockTest
- scrollTest
- zircuitTest

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
### TO-DO

- Change deploy scripts to be marked as ${chain}Test and make ${chain} deployment for mainnet