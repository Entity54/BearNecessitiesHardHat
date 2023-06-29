//SPDX-License-Identifier: MIT
pragma solidity >=0.7.6;
 
interface IUsersRegistry {
    function registerUser(address _userEVMadddress , string memory _userEVMAddressString, string memory _userChain, string memory _userSubstrateAddressString, string memory _userHex) external;
}