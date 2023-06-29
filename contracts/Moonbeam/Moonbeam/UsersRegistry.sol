//SPDX-License-Identifier: MIT
pragma solidity >=0.7.6;


contract UsersRegistry { 

    address public admin;  

    struct User {
        address   userEVMAddress;
        string    userEVMAddressString;    
        string    userChain;            //ASTAR,INTERLAY,MOONBEAM
        string    userSubstrateAddressString;  
        string    usererHex;
    }   

    mapping(address => User) public users;           
    mapping(address => bool) public isUserRegistered;          

    // mapping(address => uint) public userBalance;        //tokenAddress => balance    

    modifier onlyAdmin {
        require(msg.sender==admin,"action only for admin");
        _;
    }  

    constructor() {
        admin = msg.sender;
    }
   
    // 0xa95b7843825449DC588EC06018B48019D1111000,"0xa95b7843825449DC588EC06018B48019D1111000","Moonbeam","5HWdttFeYE89GQDGNRYspsJouxZ56xwm6bzKxSPtbDjwpQbb","a95b7843825449DC588EC06018B48019D1111000D1111000"
    // 0xa95b7843825449DC588EC06018B48019D1111000,"0xa95b7843825449DC588EC06018B48019D1111000","INTERLAY","5HWdttFeYE89GQDGNRYspsJouxZ56xwm6bzKxSPtbDjwpQbb","01f0f4360fc5dbb8cd7107edf24fc3f3c9ef3914b32585062bfd7aa84e02f8b84e00"
    // 0xa95b7843825449DC588EC06018B48019D1111000,"0xa95b7843825449DC588EC06018B48019D1111000","ASTAR","5HWdttFeYE89GQDGNRYspsJouxZ56xwm6bzKxSPtbDjwpQbb","01f0f4360fc5dbb8cd7107edf24fc3f3c9ef3914b32585062bfd7aa84e02f8b84e00"
    function registerUser(address _userEVMadddress , string memory _userEVMAddressString, string memory _userChain, string memory _userSubstrateAddressString, string memory _userHex) external {
            
            if (!isUserRegistered[_userEVMadddress])
            {
                users[_userEVMadddress] = User({ 
                                                        userEVMAddress: _userEVMadddress, 
                                                        userEVMAddressString: _userEVMAddressString, 
                                                        userChain: _userChain, 
                                                        userSubstrateAddressString: _userSubstrateAddressString, 
                                                        usererHex: _userHex 
                                                    });
                isUserRegistered[_userEVMadddress] = true;
            }
    }  

    function getUserChain(address _userEVMadddress) external view returns(string memory){
            return users[_userEVMadddress].userChain;
    }


}