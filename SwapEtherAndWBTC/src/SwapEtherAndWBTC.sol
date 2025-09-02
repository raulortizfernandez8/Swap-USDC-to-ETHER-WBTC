//SPDX-License-Identifier: MIT
// For testing in Arbytrum: Forge test -vvvv --fork-url https://arb1.arbitrum.io/rpc --match-test

pragma solidity 0.8.28;

import "../src/UniswapRouter02.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";
contract SwapApp {
    using SafeERC20 for IERC20;

    address public addressV2Router02; // Router address where the functions are.
    address public constant WETH = 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1;

    event SwapTokens(address tokenIn,address tokenOut,uint256 amountIn,uint256 amountOut);
    constructor(address addressV2Router02_){
        addressV2Router02 = addressV2Router02_;
    }
    function swapTokens(uint256 amountIn_,uint256 amountOutMin_,address[] memory path_,uint256 deadline_) external{
        // We need to send the token to the contract to be swapped.
        IERC20(path_[0]).safeTransferFrom(msg.sender, address(this), amountIn_); // We dont need to approve nothing here. The sender will aprove this contract in the moment the function is called.
        IERC20(path_[0]).approve(addressV2Router02, amountIn_);
        uint256[] memory amountOut= UniswapRouter02(addressV2Router02).swapExactTokensForTokens(amountIn_, amountOutMin_, path_, msg.sender, deadline_);
        emit SwapTokens(path_[0], path_[path_.length-1], amountIn_, amountOut[amountOut.length-1]);
    }
    function swapTokensForEther(uint256 amountIn_,uint256 amountOutMin_,address[] memory path_,uint256 deadline_) external{
        // We need to send the token to the contract to be swapped.
        require(path_[path_.length-1]==WETH,"Not correct path");
        IERC20(path_[0]).safeTransferFrom(msg.sender,address(this),amountIn_);
        IERC20(path_[0]).approve(addressV2Router02, amountIn_);
        uint256[] memory amountOut= UniswapRouter02(addressV2Router02).swapExactTokensForETH(amountIn_, amountOutMin_, path_, msg.sender, deadline_);
        // Address(0) is used to represent the native token. In Arbytrum where this contract will be deployed the native token is ETHER.
        emit SwapTokens(path_[0], address(0), amountIn_, amountOut[amountOut.length-1]);
    }
}