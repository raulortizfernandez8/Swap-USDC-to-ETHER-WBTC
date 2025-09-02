# Swap-USDC-to-ETHER-WBTC
This project demonstrates how to build and test a smart contract that allows users to easily swap tokens and native ETH on the Arbitrum One network.  At its core, it is a simple wrapper around the Uniswap V2 router, exposing functions that let anyone:  Swap one ERC20 token for another  and Swap an ERC20 token for native ETH. Tested in Foundry
# 🔎 How It Works

- **Contract (SwapApp)**

    - Receives tokens from the user

    - Approves the Uniswap V2 router

    - Executes the swap on Uniswap

    - Sends the output (tokens or ETH) back to the user

    - Emits an event with swap details

- **Router**

    - The contract delegates swaps to the Uniswap V2 router deployed on Arbitrum.

    - When swapping to ETH, the router automatically unwraps WETH to native ETH.

    - A require enforces that the last element of the path is indeed WETH, preventing invalid swap paths.

# 🧪 Testing

The test suite is written in Foundry and runs against a fork of Arbitrum mainnet, meaning it uses real tokens and liquidity pools.

**What is tested:**

- **Deployment**

    - The contract is deployed correctly with the expected Uniswap router address.

- **Token → Token swap (USDT → WBTC)**

    - The user approves SwapApp to spend USDT

    - swapTokens is called with a USDT→WBTC path

- **Assertions check:**

    - The user’s USDT balance decreases by exactly the input amount

    - The user’s WBTC balance increases

- **Token → ETH swap (USDT → ETH)**

    - The user approves SwapApp to spend USDT

    - swapTokensForEther is called with a USDT→WETH path

- **Assertions check:**

    - The require ensures that the last token in the path is WETH (valid path check)

    - The user’s USDT balance decreases by exactly the input amount

    - The user’s native ETH balance increases

    - This ensures both swap paths (ERC20→ERC20 and ERC20→ETH) work as expected with real liquidity and correct input validation.

  <img width="679" height="116" alt="image" src="https://github.com/user-attachments/assets/8e58ec9a-c20a-4ea7-928d-4a3850e76c7f" />


# 🧪 Why Forked Testing?

Instead of simulating swaps with fake tokens, this project shows how to test against real tokens and pools.

By forking Arbitrum mainnet:

You can test real swaps as if they were happening on-chain

You don’t need to deploy new liquidity pools or mock routers

You gain confidence that the contract logic works with real protocols

# ⚠️ Things to Keep in Mind

In production, always protect against MEV and price changes by setting a realistic minimum output.

Tests use a real USDT holder address on Arbitrum. If this account no longer has funds in the future, you’ll need to update it or pin to a specific block.

