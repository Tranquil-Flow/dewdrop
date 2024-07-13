// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/// @title Mainnet Faucet contract
/// @author Tranquil-Flow
/// @notice A contract that allows the owner to distribute funds to any address
/// @dev Funds are only sent after a user provides their proof of identity and is only callable once per contract
contract MainnetFaucet is Ownable, ReentrancyGuard {
    uint public faucetAmount = 0.0001 ether;        // Change this to the desired faucet amount

    error InsufficientFaucetBalance();
    error TransferFailed();
    error WithdrawalFailed();

    event FundsDistributed(address indexed recipient, uint faucetAmount);

    constructor() Ownable(msg.sender) {}

    /// @notice Distributes funds from the faucet to the specified receipient
    /// @param recipient The address to send the funds to
    function requestFunds(address recipient) external onlyOwner nonReentrant {
        if (address(this).balance < faucetAmount) {
            revert InsufficientFaucetBalance();
        }

        (bool success, ) = recipient.call{value: faucetAmount}("");
        if (!success) {
            revert TransferFailed();
        }

        emit FundsDistributed(recipient, faucetAmount);
    }

    /// @notice Withdraws all funds from the contract to the owner
    function withdraw() external onlyOwner {
        uint balance = address(this).balance;
        (bool success, ) = owner().call{value: balance}("");
        if (!success) {
            revert WithdrawalFailed();
        }
    }

    /// @notice Changes the amount of funds that the faucet will distribute per request
    function changeFaucetAmount(uint newAmount) external onlyOwner {
        faucetAmount = newAmount;
    }

    receive() external payable {}
}