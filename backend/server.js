require('dotenv').config();
const express = require('express');
const { ethers } = require('ethers');
const cors = require('cors');

const app = express();
const port = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

// Updated ABI of your MainnetFaucet contract
const FAUCET_ABI = [
  "function requestFunds(address recipient) external",
  "function withdraw() external",
  "function changeFaucetAmount(uint256 newAmount) external",
  "function faucetAmount() view returns (uint256)"
];

const provider = new ethers.JsonRpcProvider(process.env.RPC_URL);
const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);
const faucetContract = new ethers.Contract(process.env.CONTRACT_ADDRESS, FAUCET_ABI, wallet);

app.post('/request-funds', async (req, res) => {
  const { recipient } = req.body;

  try {
    const tx = await faucetContract.requestFunds(recipient);
    await tx.wait();
    res.json({ success: true, txHash: tx.hash });
  } catch (error) {
    console.error('Error requesting funds:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

app.post('/withdraw', async (req, res) => {
  try {
    const tx = await faucetContract.withdraw();
    await tx.wait();
    res.json({ success: true, txHash: tx.hash });
  } catch (error) {
    console.error('Error withdrawing funds:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

app.post('/change-faucet-amount', async (req, res) => {
  const { newAmount } = req.body;
  try {
    const tx = await faucetContract.changeFaucetAmount(ethers.parseEther(newAmount));
    await tx.wait();
    res.json({ success: true, txHash: tx.hash });
  } catch (error) {
    console.error('Error changing faucet amount:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

app.get('/faucet-amount', async (req, res) => {
  try {
    const amount = await faucetContract.faucetAmount();
    res.json({ amount: ethers.formatEther(amount) });
  } catch (error) {
    console.error('Error getting faucet amount:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});