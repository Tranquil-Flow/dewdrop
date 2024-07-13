// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract MainnetFaucet is Ownable, ReentrancyGuard {
    uint public faucetAmount = 0.0001 ether;

    error InsufficientFaucetBalance();
    error TransferFailed();
    error WithdrawalFailed();

    event FundsDistributed(address indexed recipient, uint faucetAmount);

    constructor() Ownable(msg.sender) {}

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

    function withdraw() external onlyOwner {
        uint balance = address(this).balance;
        (bool success, ) = owner().call{value: balance}("");
        if (!success) {
            revert WithdrawalFailed();
        }
    }

    function changeFaucetAmount(uint newAmount) external onlyOwner {
        faucetAmount = newAmount;
    }

    receive() external payable {}
}