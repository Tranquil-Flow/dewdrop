// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract MainnetFaucet is Ownable, ReentrancyGuard {
    error InsufficientFaucetBalance();
    error TransferFailed();
    error WithdrawalFailed();

    event FundsDistributed(address indexed recipient, uint amount);

    constructor() Ownable(msg.sender) {}

    function requestFunds(address recipient, uint amount) external onlyOwner nonReentrant {
        if (address(this).balance < amount) {
            revert InsufficientFaucetBalance();
        }

        (bool success, ) = recipient.call{value: amount}("");
        if (!success) {
            revert TransferFailed();
        }

        emit FundsDistributed(recipient, amount);
    }

    function withdraw() external onlyOwner {
        uint balance = address(this).balance;
        (bool success, ) = owner().call{value: balance}("");
        if (!success) {
            revert WithdrawalFailed();
        }
    }

    receive() external payable {}
}