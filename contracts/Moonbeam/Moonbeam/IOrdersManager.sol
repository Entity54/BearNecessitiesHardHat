//SPDX-License-Identifier: MIT
pragma solidity >=0.7.6;
 
interface IOrdersManager {
    function submit_Order(address _owner, address tokenIn, address tokenOut, uint limit_price, uint stop_price, uint size, uint num_Ofsplits, uint order_type, uint _dcaBlockInterval ) external;
    function delete_Order(uint order_nonce) external; 
}