//SPDX-License-Identifier: MIT
pragma solidity >=0.7.6;

// import {IAxelarGateway} from "https://github.com/axelarnetwork/axelar-gmp-sdk-solidity/blob/main/contracts/interfaces/IAxelarGateway.sol";
// import {IAxelarGasService} from "https://github.com/axelarnetwork/axelar-gmp-sdk-solidity/blob/main/contracts/interfaces/IAxelarGasService.sol";
// import {AxelarExecutable} from "https://github.com/axelarnetwork/axelar-gmp-sdk-solidity/blob/main/contracts/executable/AxelarExecutable.sol"; //"@axelar-network/axelar-gmp-sdk-solidity/contracts/executable/AxelarExecutable.sol";
// import { AddressToString } from "https://github.com/axelarnetwork/axelar-gmp-sdk-solidity/blob/main/contracts/utils/AddressString.sol";
// import './IERC20.sol';

import {IAxelarGateway} from "@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGateway.sol";
import {IAxelarGasService} from "@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGasService.sol";
import {AxelarExecutable} from "@axelar-network/axelar-gmp-sdk-solidity/contracts/executable/AxelarExecutable.sol"; 
import { AddressToString } from "@axelar-network/axelar-gmp-sdk-solidity/contracts/utils/AddressString.sol";
import '../../IERC20.sol';

import './IOrdersManager.sol';
import './IUsersRegistry.sol';




//Gas Service Contract: 0x2d5d7d31F671F86C782533cc367F14109a082712
//Chain Name: Moonbeam  Gateway Contract: 0x4F4495243837681061C4743b74B3eEdf548D56A5  axlUSDC 0xCa01a1D0993565291051daFF390892518ACfAD3A
//Chain Name  Fantom    Gateway Contract: 0x304acf330bbE08d1e512eefaa92F6a57871fD895  axlUSDC 0x1B6382DBDEa11d97f24495C9A90b7c88469134a4

contract AxelarMoonbeamSatelite is AxelarExecutable {  
    using AddressToString for address;
    IAxelarGasService public immutable gasService;
    string public satelite_Fantom_address;

    // using OrdersManager for OrdersManager.Order;

    address public ordersManager_address;
    address public usersRegistry_address;

    address public admin;  
    address public constant USDC_address = 0x931715FEE2d06333043d11F658C8CE934aC61D0c;     //6 decimals. TO CHECK
    address public constant axlUSDC_address = 0xCa01a1D0993565291051daFF390892518ACfAD3A;  //6 decimals. TO CHECK

    IERC20 public axlUSDC;

    string public sourceChain;
    string public sourceAddress;
   

    uint256 public _messageCode;
    uint256 public _nonce;
    address public _owner;
    address public _tokenIn; 
    address public _tokenOut; 
    uint256 public _limit_price;
    uint256 public _stop_price; 
    uint256 public _size; 
    uint256 public _num_Ofsplits; 
    uint256 public _order_type; 
    uint256 public _dcaBlockInterval; 

    uint256 public _messageCode2;
    uint256 public _nonce2;
    address public _owner2;


    bool public orderIsdeleted;


    modifier onlyAdmin {
        require(msg.sender==admin,"action only for admin");
        _;
    }  

// 0x4F4495243837681061C4743b74B3eEdf548D56A5,0x2d5d7d31F671F86C782533cc367F14109a082712   //Mainnet
    constructor(address _gateway, address _gasReceiver) AxelarExecutable(_gateway) {
        admin = msg.sender;
        gasService = IAxelarGasService(_gasReceiver);
        axlUSDC = IERC20(axlUSDC_address);
    }
   
    // 0x2b637e9a157d015580CA6cD0223d48cFCcbC3aFb
    function set_FantomSatelite(address _satelite_Fantom_address) external onlyAdmin {
        satelite_Fantom_address = _satelite_Fantom_address.toString();
    }
    // 0x9331d7e0F7deD78a21d6A3d381cdc95Da689AF79,0xC11029E655456618bC9FaDFF92B52D99863A9A55
    function set_OrdersManager(address _ordersManager_address, address _usersRegistry_address) external onlyAdmin {
        ordersManager_address = _ordersManager_address;
        usersRegistry_address = _usersRegistry_address;
    }
     
    /// Receive instructions to Register User from Fantom, submitOrder, deleteOrder
    function _execute(string calldata sourceChain_, string calldata sourceAddress_, bytes calldata payload) internal override {
        sourceChain = sourceChain_;
        sourceAddress = sourceAddress_;

        (uint256 messageCode, uint256 nonce, address owner, address tokenIn, address tokenOut, uint256 limit_price, uint256 stop_price, uint256 size, uint256 num_Ofsplits, uint256 order_type, uint256 dcaBlockInterval  ) = abi.decode(payload, (uint256,uint256,address,address,address,uint256,uint256,uint256,uint256,uint256,uint256));

        if (messageCode==1)
        {
            // Register User
            IUsersRegistry(usersRegistry_address).registerUser(owner , owner.toString(), "FANTOM", "", "");

            //Submit Order
            IOrdersManager(ordersManager_address).submit_Order(owner,tokenIn,tokenOut,limit_price,stop_price,size,num_Ofsplits,order_type,dcaBlockInterval);
        }
        else if (messageCode==2)
        {
            orderIsdeleted = false;
            // //TODO
            // address memory ordOwner =  OrdersManager(ordersManager_address).getOrderOwner(nonce);

            // if (ordOwner==owner)
            // {
                    //Delete Order
                    IOrdersManager(ordersManager_address).delete_Order(nonce);
                    orderIsdeleted = true;
            // }
        }

        //Only for testing
        _messageCode = messageCode;
        _nonce = nonce;
        _owner = owner;
        _tokenIn = tokenIn;
        _tokenOut = tokenOut;
        _limit_price = limit_price;
        _stop_price = stop_price;
        _size = size;
        _num_Ofsplits = num_Ofsplits;
        _order_type= order_type;
        _dcaBlockInterval= dcaBlockInterval;
       
    }


    

    


  

}