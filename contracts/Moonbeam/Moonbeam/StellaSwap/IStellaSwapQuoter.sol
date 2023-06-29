// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.5.0;

interface IStellaSwapQuoter {
    function quoteExactOutputSingle( address tokenIn, address tokenOut, uint256 amountOut, uint160 limitSqrtPrice) external returns (uint256 amountIn, uint16 fee); 
    function quoteExactOutput(bytes memory path, uint256 amountOut) external returns (uint256 amountIn, uint16[] memory fees);
    function quoteExactInput(bytes memory path, uint256 amountIn) external returns (uint256 amountOut, uint16[] memory fees);
    function quoteExactInputSingle( address tokenIn, address tokenOut, uint256 amountIn, uint160 limitSqrtPrice) external returns (uint256 amountOut, uint16 fee);
}