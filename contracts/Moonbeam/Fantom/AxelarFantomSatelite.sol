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



//Gas Service Contract: 0x2d5d7d31F671F86C782533cc367F14109a082712
//Chain Name: Moonbeam  Gateway Contract: 0x4F4495243837681061C4743b74B3eEdf548D56A5  axlUSDC 0xCa01a1D0993565291051daFF390892518ACfAD3A
//Chain Name  Fantom    Gateway Contract: 0x304acf330bbE08d1e512eefaa92F6a57871fD895  axlUSDC 0x1B6382DBDEa11d97f24495C9A90b7c88469134a4
contract AxelarFantomSatelite is AxelarExecutable {  
    using AddressToString for address;
    IAxelarGasService public immutable gasService;
    string public satelite_Moonbeam_address;
    string public executionOrdersEngineFromFatnomInMoomnbeam_address;

    address public admin;  
    IERC20 public axlUSDC;
    
    //MOONBEAM TOKEN ADDRESSES
    address public constant xcASTR_address = 0xFfFFFfffA893AD19e540E172C10d78D4d479B5Cf;
    address public constant WGLMR_address = 0xAcc15dC74880C9944775448304B263D191c6077F;    //18 decimals
    address public constant xcDOT_address = 0xFfFFfFff1FcaCBd218EDc0EbA20Fc2308C778080;    //10 decimals
    address public constant USDC_address = 0x931715FEE2d06333043d11F658C8CE934aC61D0c;     //6 decimals
 
    uint256[] public finance_orderNonces; 
    address[] public finance_OrderOwnerAddresses;
    uint256[] public finance_OrderSizes;

            uint public totalAmountToSend;
            uint256[] public finance_Order_Nonces_ToSend;  
            uint256[] public finance_Order_Sizes_ToSend;  
            address[] public finance_Order_Owners_ToSend;  
            uint256[] public finance_Order_Nonces_ToDelete;  

    string public sourceChain;
    string public sourceAddress;

    //For Testing
    uint public received_messageCode;
    uint256[] public received_order_Nonces; 
    address[] public received_order_OwnerAddresses;
    uint256[] public received_order_Sizes;


    modifier onlyAdmin {
        require(msg.sender==admin,"action only for admin");
        _;
    }  
                                                                                                                                                                                       
// For Axelar Fee  use 1000000000000000000  1 FTM.   Base Fee 500000000000000000 0.5 FTM  18 decimals 
// 0x304acf330bbE08d1e512eefaa92F6a57871fD895,0x2d5d7d31F671F86C782533cc367F14109a082712   //Mainnet 0x2b637e9a157d015580CA6cD0223d48cFCcbC3aFb
    constructor(address _gateway, address _gasReceiver) AxelarExecutable(_gateway) {
        admin = msg.sender;
        gasService = IAxelarGasService(_gasReceiver);
    }
    
 // 0x20fA8B1ED4EFb8eeF8190b5877741e6561E72e32,0x711bc8E7b6639B706db7D1daFad68ff6FEC689f9  
    function set_MoonbeamSatelite(address _satelite_Moonbeam_address, address _executionOrdersEngineFromFatnomInMoomnbeam_address) external onlyAdmin {
        satelite_Moonbeam_address = _satelite_Moonbeam_address.toString();
        executionOrdersEngineFromFatnomInMoomnbeam_address = _executionOrdersEngineFromFatnomInMoomnbeam_address.toString();

        address axlUSDC_tokenAddress = gateway.tokenAddresses("axlUSDC");
        axlUSDC = IERC20(axlUSDC_tokenAddress);
    }
 
 
// Make sure you increase allowance 
//  0x931715FEE2d06333043d11F658C8CE934aC61D0c,0xFfFFfFff1FcaCBd218EDc0EbA20Fc2308C778080,10110257,0,102222,0,1,0
//  0x931715FEE2d06333043d11F658C8CE934aC61D0c,0xFfFFfFff1FcaCBd218EDc0EbA20Fc2308C778080,5110257,0,102222,0,1,0
//  0x931715FEE2d06333043d11F658C8CE934aC61D0c,0xFfFFfFff1FcaCBd218EDc0EbA20Fc2308C778080,4321012,0,101234,0,1,0

// HERE TIME TO SEND A SELL FOR xcDOT
// 0xFfFFfFff1FcaCBd218EDc0EbA20Fc2308C778080,0x931715FEE2d06333043d11F658C8CE934aC61D0c,0,5910257,100372954,0,2,0

    function submitOrderTo_Moonbeam(address tokenIn, address tokenOut, uint limit_price, uint stop_price, uint size, uint num_Ofsplits, uint order_type, uint _dcaBlockInterval ) external payable { 
        uint messageCode = 1;
        bytes memory payload = abi.encode(messageCode, 0, msg.sender, tokenIn, tokenOut, limit_price, stop_price, size, num_Ofsplits, order_type, _dcaBlockInterval);
        sendMessage("Moonbeam", satelite_Moonbeam_address, payload);
    }

//make sure you decrease allowance      
//257
    function cancelOrderTo_Moonbeam(uint256 orderNonce) external payable {
        uint messageCode = 2;
        bytes memory payload = abi.encode(messageCode, orderNonce, msg.sender, address(0), address(0), 0, 0, 0, 0, 0, 0);
        sendMessage("Moonbeam", satelite_Moonbeam_address, payload);
    } 

    ///Axelar Send Message
    function sendMessage(string memory destinationChain, string memory destinationAddress, bytes memory payload ) public payable {
       
        if (msg.value > 0) {
            gasService.payNativeGasForContractCall{value: msg.value}(
                address(this),
                destinationChain,
                destinationAddress,
                payload,
                msg.sender
            );
        }
        gateway.callContract(destinationChain, destinationAddress, payload);
    }

    function _execute(string calldata sourceChain_, string calldata sourceAddress_, bytes calldata payload) internal override {
        sourceChain = sourceChain_;
        sourceAddress = sourceAddress_;
        (uint256 messageCode, uint256[] memory orderNonces, address[] memory orderOwnerAddresses, uint256[] memory orderAmounts) = abi.decode(payload, (uint256,uint256[],address[],uint256[]));

        if (messageCode==3) //transferFrom axlUSDC from order owners to execute Limit or DCA orders
        {
            for (uint i=0; i< orderNonces.length; i++)
            {
                finance_orderNonces.push(orderNonces[i]);
                finance_OrderOwnerAddresses.push(orderOwnerAddresses[i]);
                finance_OrderSizes.push(orderAmounts[i]);
            }
        }

        //FOR TESTING ONLY
        received_messageCode = messageCode;
        received_order_Nonces = orderNonces;
        received_order_OwnerAddresses = orderOwnerAddresses;
        received_order_Sizes = orderAmounts;
    }
 
    function requestOrderAXLUSDCfinancing() external { 
        //ToDo Run only if finance_orderNonces.length > 0
        if (finance_orderNonces.length > 0)
        {
            totalAmountToSend = 0;

            for (uint i=0; i< finance_orderNonces.length; i++)
            {
                uint allowance = axlUSDC.allowance( finance_OrderOwnerAddresses[i], address(this));
                uint balance = axlUSDC.balanceOf( finance_OrderOwnerAddresses[i]);

                if (allowance>=finance_OrderSizes[i] && balance>=finance_OrderSizes[i])
                {
                    axlUSDC.transferFrom(finance_OrderOwnerAddresses[i],address(this), finance_OrderSizes[i]); 
                    totalAmountToSend +=finance_OrderSizes[i];

                    finance_Order_Nonces_ToSend.push( finance_orderNonces[i] );
                    finance_Order_Owners_ToSend.push( finance_OrderOwnerAddresses[i] );
                    finance_Order_Sizes_ToSend.push( finance_OrderSizes[i] );
                }
                else 
                {
                    finance_Order_Nonces_ToDelete.push( finance_orderNonces[i] );
                }

            }
        
            delete finance_orderNonces;
            delete finance_OrderOwnerAddresses;
            delete finance_OrderSizes;
        }
    }

    // REMEMBER TO ALWAYS CHECK finance_Order_Nonces_ToSend.length > 0
    function financeOrdersTo_Execute() external payable {
        if (finance_Order_Nonces_ToSend.length > 0 )
        {
            sendToMany("Moonbeam",executionOrdersEngineFromFatnomInMoomnbeam_address,4, 
                            finance_Order_Nonces_ToSend, 
                            finance_Order_Owners_ToSend, 
                            finance_Order_Sizes_ToSend, 
                            "axlUSDC",
                            totalAmountToSend);

            delete finance_Order_Nonces_ToSend;
            delete finance_Order_Owners_ToSend;
            delete finance_Order_Sizes_ToSend;               
        }
    }
    function financeOrdersTo_Delete() external payable {
        if (finance_Order_Nonces_ToDelete.length > 0 )
        {
            bytes memory payload = abi.encode(4, finance_Order_Nonces_ToDelete);
            sendMessage("Moonbeam", executionOrdersEngineFromFatnomInMoomnbeam_address, payload);
        }
    }

    function sendToMany( string memory destinationChain, string memory destinationAddress, uint256 _messageCode, uint256[] memory _orderNonces, address[] memory _destinationAddresses, uint256[] memory _destinationAmounts, string memory symbol, uint256 amount) public payable {
        address tokenAddress = gateway.tokenAddresses(symbol);
        IERC20(tokenAddress).approve(address(gateway), amount);
        bytes memory payload = abi.encode(_messageCode,_orderNonces,_destinationAddresses,_destinationAmounts);

        if (msg.value > 0) {
            gasService.payNativeGasForContractCallWithToken{ value: msg.value }(
                address(this),
                destinationChain,
                destinationAddress,
                payload,
                symbol,
                amount,
                msg.sender
            );
        }
        gateway.callContractWithToken(destinationChain, destinationAddress, payload, symbol, amount);
    }


    //Receiving axlUSDC when selling order executes at Moonbeam
    // function _executeWithToken(string calldata, string calldata , bytes calldata payload, string calldata symbol, uint256 amount ) internal override {
    function _executeWithToken(string calldata sourceChain_, string calldata sourceAddress_, bytes calldata payload, string calldata, uint256) internal override {
        sourceChain = sourceChain_;
        sourceAddress = sourceAddress_;
        
        (uint256 _messageCode, address _ownerAddress, uint256 _ownerAmount) = abi.decode(payload, (uint256,address,uint256));

        if (_messageCode==5)
        {
            // if you want you can swap axlUSDC to USDC first and then transfer USDC to user's account. This requires Curve
            axlUSDC.transfer(_ownerAddress,_ownerAmount);
        }
    }

    function get_finance_Order_Nonces_ToSend() external view returns(uint[] memory) {
        return finance_Order_Nonces_ToSend;
    }
    function get_finance_Order_Nonces_ToDelete() external view returns(uint[] memory) {
        return finance_Order_Nonces_ToDelete;
    }
    function get_finance_Order_Sizes_ToSend() external view returns(uint[] memory) {
        return finance_Order_Sizes_ToSend;
    }
    function get_finance_Order_Owners_ToSend() external view returns(address[] memory) {
        return finance_Order_Owners_ToSend;
    }

    function get_finance_orderNonces() external view returns(uint[] memory) {
        return finance_orderNonces;
    }
    function get_finance_OrderOwnerAddresses() external view returns(address[] memory) {
        return finance_OrderOwnerAddresses;
    }
    function get_finance_OrderSizes() external view returns(uint[] memory) {
        return finance_OrderSizes;
    }

    function get_received_order_Nonces() external view returns(uint[] memory) {
        return received_order_Nonces;
    }
    function get_received_order_OwnerAddresses() external view returns(address[] memory) {
        return received_order_OwnerAddresses;
    }
    function get_received_order_Sizes() external view returns(uint[] memory) {
        return received_order_Sizes;
    }
    
    //ONLY FOR TESTING
    function getOurTokensOut() external   {
        axlUSDC.transfer(msg.sender, axlUSDC.balanceOf(address(this)) );
    }
}