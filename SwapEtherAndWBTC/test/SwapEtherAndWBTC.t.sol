//SPDX-License-Identifier: MIT
// Forge test -vvvv --fork-url https://arb1.arbitrum.io/rpc --match-test nombredelafuncionparatestear
pragma solidity 0.8.28;

import "../lib/forge-std/src/Test.sol";
import "../src/SwapEtherAndWBTC.sol";

contract SwapAppTest is Test{

    SwapApp swapapp;
    address V2Routeraddress_ = 0x4752ba5DBc23f44D87826276BF6Fd6b1C372aD24; // This can be found in Uniswap docs.
    address userWithUSDT = 0xab04AA25533401977F8E0350A9b9B1D7f145f69c; // This address contains USDT
    address USDT = 0xFd086bC7CD5C481DCC9C85ebE478A1C0b69FCbb9; // This is the USDT address
    address WBTC = 0x2f2a2543B76A4166549F7aaB2e75Bef0aefC5B0f; // This is the WBTC address
    address WETH = 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1; // This is the WETH address
    function setUp() public{
        swapapp = new SwapApp(V2Routeraddress_);
    }   
    function testDeployedCorrectly() public view{
        assert(swapapp.addressV2Router02() == V2Routeraddress_);
    }
    function testSwapToken() public{
        vm.startPrank(userWithUSDT);

        uint256 amountIn = 3*1e6; // USDT has 6 decimals
        uint256 amountOutMin = 9; // WBTC has 8 decimals.
        address [] memory path = new address[](2);
        path[0]= USDT;
        path[1]=WBTC;
        uint256 deadline = block.timestamp + 10000;

        IERC20(USDT).approve(address(swapapp),amountIn);
        uint256 balanceBeforeUSDT = IERC20(USDT).balanceOf(userWithUSDT);
        uint256 balanceBeforeWBTC = IERC20(WBTC).balanceOf(userWithUSDT);
        swapapp.swapTokens(amountIn, amountOutMin, path, deadline);
        uint256 balanceAfterUSDT = IERC20(USDT).balanceOf(userWithUSDT);
        uint256 balanceAfterWBTC = IERC20(WBTC).balanceOf(userWithUSDT);
        assert(balanceBeforeUSDT==balanceAfterUSDT+amountIn);
        assert(balanceAfterWBTC>balanceBeforeWBTC);
        vm.stopPrank();

    }
    function testSwapTokenForEther() public{
        vm.startPrank(userWithUSDT);

        uint256 amountIn = 3*1e6; // USDT has 6 decimals
        uint256 amountOutMin = 9*1e2; // WETH has 18 decimals.
        address [] memory path = new address[](2);
        path[0]= USDT;
        path[1]=WETH;
        uint256 deadline = block.timestamp + 10000;

        IERC20(USDT).approve(address(swapapp),amountIn);
        uint256 balanceBeforeUSDT = IERC20(USDT).balanceOf(userWithUSDT);
        uint256 balanceBeforeETH = userWithUSDT.balance;
        swapapp.swapTokensForEther(amountIn, amountOutMin, path, deadline);
        uint256 balanceAfterUSDT = IERC20(USDT).balanceOf(userWithUSDT);
        uint256 balanceAfterETH = userWithUSDT.balance;
        assert(balanceBeforeUSDT==balanceAfterUSDT+amountIn);
        assert(balanceAfterETH>balanceBeforeETH);
        vm.stopPrank();

    }
    function testShouldRevertNotCorrectPath() public{
        vm.startPrank(userWithUSDT);

        uint256 amountIn = 3*1e6; // USDT has 6 decimals
        uint256 amountOutMin = 9*1e2; // WETH has 18 decimals.
        address [] memory path = new address[](2);
        path[0]= USDT;
        path[1]=WBTC;
        uint256 deadline = block.timestamp + 10000;

        IERC20(USDT).approve(address(swapapp),amountIn);
        vm.expectRevert("Not correct path");
        swapapp.swapTokensForEther(amountIn, amountOutMin, path, deadline);
        
        vm.stopPrank();

    }

}
