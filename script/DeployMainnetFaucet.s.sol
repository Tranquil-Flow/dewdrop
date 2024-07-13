// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import "forge-std/Script.sol";
import "../src/MainnetFaucet.sol";

contract DeployMainnetFaucet is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        uint256 chainId;
        assembly {
            chainId := chainid()
        }
        string memory chainName = getMainnetChainName(chainId);

        require(bytes(chainName).length > 0, "Deployment is only allowed on recognized mainnets");

        console.log("Deploying MainnetFaucet on:", chainName);

        vm.startBroadcast(deployerPrivateKey);

        MainnetFaucet faucet = new MainnetFaucet();
        console.log("MainnetFaucet deployed at:", address(faucet));

        vm.stopBroadcast();

        console.log("Deployment completed on", chainName);
    }

    function getMainnetChainName(uint256 chainId) internal pure returns (string memory) {
        if (chainId == 42161) return "Arbitrum One";
        if (chainId == 8453) return "Base";
        if (chainId == 42220) return "Celo";
        if (chainId == 30) return "Rootstock";
        if (chainId == 534352) return "Scroll";
        if (chainId == 48900) return "Zircuit";
        return "";
    }
}