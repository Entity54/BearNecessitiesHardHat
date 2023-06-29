// SPDX-License-Identifier: MIT
pragma solidity  >=0.6.0;
 
interface IStableSwap {
    function swap(
        uint8 tokenIndexFrom,
        uint8 tokenIndexTo,
        uint256 dx,
        uint256 minDy,
        uint256 deadline
    ) external returns (uint256);
    function getLpToken() external returns (address);
    function getToken(uint8 index) external returns (address);
} 