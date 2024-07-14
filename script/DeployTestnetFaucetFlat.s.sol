// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import "forge-std/Script.sol";
import "../src/MainnetFaucetFlat.sol";

contract DeployTestnetFaucetFlat is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployerAddress = vm.addr(deployerPrivateKey);
        uint256 initialFunding = 0.01 ether; // Amount to fund the contract with

        uint256 chainId;
        assembly {
            chainId := chainid()
        }
        string memory chainName = getTestnetChainName(chainId);

        require(bytes(chainName).length > 0, "Deployment is only allowed on recognized testnets");

        console.log("Deploying TestnetFaucetFlat on:", chainName);

        vm.startBroadcast(deployerPrivateKey);

        MainnetFaucet faucet = new MainnetFaucet();
        console.log("TestnetFaucetFlat deployed at:", address(faucet));
        console.log("Deployer and Owner of contract is:", deployerAddress);

        // Fund the contract
        (bool success, ) = address(faucet).call{value: initialFunding}("");
        require(success, "Funding failed");
        console.log("Funded contract with:", initialFunding);

        vm.stopBroadcast();

        console.log("Deployment and funding completed on", chainName);
    }

    function getTestnetChainName(uint256 chainId) internal pure returns (string memory) {
        if (chainId == 1798) return "Apechain Jenkins Testnet";
        if (chainId == 421614) return "Arbitrum Sepolia Testnet";
        if (chainId == 1313161555) return "Aurora Testnet (NEAR)";
        if (chainId == 84532) return "Base Sepolia Testnet";
        if (chainId == 44787) return "Celo Alfajores Testnet";
        if (chainId == 2810) return "Morph Holesky Testnet";
        if (chainId == 31) return "Rootstock Testnet";
        if (chainId == 534351) return "Scroll Sepolia Testnet";
        if (chainId == 48899) return "Zircuit Testnet";
        return "";
    }
}