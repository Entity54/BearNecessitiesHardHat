//SPDX-License-Identifier: MIT
pragma solidity >=0.7.6;
pragma abicoder v2;
 
interface IStellaSwap {
    function getBlockTimestamp() external view returns(uint256);
    function getTokenPriceUSDCwei_1Hops(address inputToken, uint256 amountIn) external returns (uint256);
    function getTokenPriceUSDCwei(address inputToken, uint256 amountIn) external returns (uint256);
    function getPrice_token1HopsUSDC_WEI(address inputToken, uint256 amountOut) external returns (uint256);
    function getPrice_token1USDC_WEI(address inputToken, uint256 amountOut) external returns (uint256);
    function stableSwapExactInput(address inputTokenAddress, address outputTokenAddress, uint256 amountIn) external payable returns (uint256 amountOut); 
    function swapExactInputSingle(address inputTokenAddress, address outputTokenAddress, uint256 amountIn) external payable returns (uint256 amountOut); 
    function swapExactInputMulti3hops(address inputTokenAddress, address hopTokenAddress, address outputTokenAddress, uint256 amountIn) external payable returns (uint256 amountOut);
    function swapExactInputMulti4hops(address inputTokenAddress, address hopTokenAddress1, address hopTokenAddress2, address outputTokenAddress, uint256 amountIn) external payable returns (uint256 amountOut);
}