//SPDX-License-Identifier: MIT
pragma solidity >=0.7.6;

// import {IAxelarGateway} from "https://github.com/axelarnetwork/axelar-gmp-sdk-solidity/blob/main/contracts/interfaces/IAxelarGateway.sol";
// import {IAxelarGasService} from "https://github.com/axelarnetwork/axelar-gmp-sdk-solidity/blob/main/contracts/interfaces/IAxelarGasService.sol";
// import {AxelarExecutable} from "https://github.com/axelarnetwork/axelar-gmp-sdk-solidity/blob/main/contracts/executable/AxelarExecutable.sol"; //"@axelar-network/axelar-gmp-sdk-solidity/contracts/executable/AxelarExecutable.sol";
// import { AddressToString } from "https://github.com/axelarnetwork/axelar-gmp-sdk-solidity/blob/main/contracts/utils/AddressString.sol";
// import './IERC20.sol';
// import './IStellaSwap.sol';  


import {IAxelarGateway} from "@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGateway.sol";
import {IAxelarGasService} from "@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGasService.sol";
import {AxelarExecutable} from "@axelar-network/axelar-gmp-sdk-solidity/contracts/executable/AxelarExecutable.sol"; 
import { AddressToString } from "@axelar-network/axelar-gmp-sdk-solidity/contracts/utils/AddressString.sol";
import '../../IERC20.sol';
import './StellaSwap/IStellaSwap.sol';  



//Gas Service Contract: 0x2d5d7d31F671F86C782533cc367F14109a082712
//Chain Name: Moonbeam  Gateway Contract: 0x4F4495243837681061C4743b74B3eEdf548D56A5  axlUSDC 0xCa01a1D0993565291051daFF390892518ACfAD3A
//Chain Name  Fantom    Gateway Contract: 0x304acf330bbE08d1e512eefaa92F6a57871fD895  axlUSDC 0x1B6382DBDEa11d97f24495C9A90b7c88469134a4

contract ExecutionOrdersEngineFromFantom is AxelarExecutable {  

    using AddressToString for address;
    IAxelarGasService public immutable gasService;
    string public satelite_FantomAddress;

    address public admin;  
    uint public engine_nonce = 0;

    address public stellaSwapAddress; 
    IStellaSwap public dex; 

    address public constant xcASTR_address = 0xFfFFFfffA893AD19e540E172C10d78D4d479B5Cf;
    address public constant WGLMR_address = 0xAcc15dC74880C9944775448304B263D191c6077F;    //18 decimals
    address public constant xcDOT_address = 0xFfFFfFff1FcaCBd218EDc0EbA20Fc2308C778080;    //10 decimals
    address public constant USDC_address = 0x931715FEE2d06333043d11F658C8CE934aC61D0c;     //6 decimals
    address public constant axlUSDC_address = 0xCa01a1D0993565291051daFF390892518ACfAD3A;  //6 decimals

    struct Order {
        uint      engine_nonce;
        uint      origin_nonce;
        address   owner;
        address   tokenIn;
        address   tokenOut;
        uint      limit_price;
        uint      stop_price;
        uint      size;
        uint      block_submitted;
        uint      order_type;   //1: limit, 2:stop, 3: brackets, 4: DCA
        uint      positionAr;   //where in the Array can I find the nonce of this order Arry can be based on type limitOrdersArray, stopOrdersArray, bracketOrdersArray, dcaOrdersArray
        bool      IsFinanced;
    }   

    mapping(uint => Order) public Orders;          //for a given noce give the Order details back

    uint[] public pendingOrders_FromFANTOM_USDC;   //orders to swap USDC for another coin
    uint[] public pendingFinancedOrders_FromFANTOM_USDC;
    uint[] public pendingOrders_FromFANTOM_NON_USDC; //orders to swap another coin fr usdc

    // records the requests from Fantom to send via Axealr to finance the order execution
    uint256[] public orderNonces_ToSend; 
    address[] public destinationAddresses_ToSend;
    uint256[] public destinationAmounts_ToSend;

    uint256[] public unfinancedOrderNoncesToDelete;

    //For testing
    // uint public receivedAmount_test;
    // uint256[] public recipientNonces;
    // address[] public recipientAddresses_test;
    // uint256[] public recipientAmounts_test;

    mapping(address => mapping(address => uint)) public userBalance;        // accountAddress => tokenAddress => balance    

    modifier onlyAdmin {
        require(msg.sender==admin,"action only for admin");
        _;
    }  

// 0x4F4495243837681061C4743b74B3eEdf548D56A5,0x2d5d7d31F671F86C782533cc367F14109a082712   //Mainnet StellaSwap 0xF7aC2a2AdEaA1EFc0Bd4130F5a28AE73A1225663
    constructor(address _gateway, address _gasReceiver) AxelarExecutable(_gateway) {
        admin = msg.sender;
        gasService = IAxelarGasService(_gasReceiver);
    }
 
    function set_FantomSatelite(address _satelite_FantomAddress) external onlyAdmin {
        satelite_FantomAddress = _satelite_FantomAddress.toString();
    }
    // 0xF7aC2a2AdEaA1EFc0Bd4130F5a28AE73A1225663
    function set_StellaSwap(address _stellaSwapAddress) external onlyAdmin {
        stellaSwapAddress = _stellaSwapAddress;
        dex = IStellaSwap(_stellaSwapAddress);
    }

    // Collects orders that are ready to be send to Exchange
    function addTo_Orders(uint _nonce, address _owner, address tokenIn, address tokenOut, uint limit_price, uint stop_price, uint size, uint block_submitted, uint order_type) external { //to be called only by Authroity Account
        uint positionAr;
        engine_nonce +=1;
        bool IsFinanced = true;

        if (tokenIn==USDC_address)
        {
            positionAr = pendingOrders_FromFANTOM_USDC.length;
            pendingOrders_FromFANTOM_USDC.push(engine_nonce);
            IsFinanced = false;
        }
        else
        {
            positionAr = pendingOrders_FromFANTOM_NON_USDC.length;
            pendingOrders_FromFANTOM_NON_USDC.push(engine_nonce);
        }

        Orders[engine_nonce] = Order({ 
                                engine_nonce: engine_nonce,
                                origin_nonce: _nonce, 
                                owner: _owner,
                                tokenIn: tokenIn,
                                tokenOut: tokenOut,
                                limit_price: limit_price,
                                stop_price: stop_price,
                                size: size,
                                block_submitted: block_submitted,
                                order_type: order_type,
                                positionAr: positionAr,
                                IsFinanced: IsFinanced
                            });

    } 


/// RUN THIS ONLY IF get_pendingOrders_FromFANTOM_USDC.LENGTH>0
// Fees GLMR 1000000000000000000 1 GLMR Base Fee 600000000000000000 0.6 GLMR
    // Takes every order with nonce at pendingOrders_FANTOM prepares data OrderNonces/OrderAddressOweners/OrderAmounts, moves orders to pendingFinancedOrders_FromFANTOM_USDC and sends via Axelar to Fantom sc to request funding
    function requestPendingOrdersFinancing() external payable {
        // NEXT RELEASE ToDo Run only if pendingOrders_FromFANTOM_USDC>0
        if (pendingOrders_FromFANTOM_USDC.length > 0)
        {
            delete orderNonces_ToSend;
            delete destinationAddresses_ToSend;
            delete destinationAmounts_ToSend;

            for (uint i=0; i<pendingOrders_FromFANTOM_USDC.length; i++)
            {
                uint engineOrderNonce = pendingOrders_FromFANTOM_USDC[i];
                Order memory pOrder = Orders[engineOrderNonce];
                orderNonces_ToSend.push(engineOrderNonce);
                destinationAddresses_ToSend.push(pOrder.owner);
                destinationAmounts_ToSend.push(pOrder.size);

                uint positionAr = pendingFinancedOrders_FromFANTOM_USDC.length;
                pendingFinancedOrders_FromFANTOM_USDC.push(engineOrderNonce);
                Orders[engineOrderNonce].positionAr = positionAr;
            }
            delete pendingOrders_FromFANTOM_USDC;

            sendMessage( 3, "Fantom", satelite_FantomAddress , orderNonces_ToSend, destinationAddresses_ToSend, destinationAmounts_ToSend);
        }
    }

    /// Send an array of order_owner addresses, an array of axlUSDC need to send to this contract, orderNonces, total amount of axlUSDC to be sent /// Send a message cross chain to a specific chain and specific contract
    function sendMessage(uint256 messageCode, string memory destinationChain, string memory destinationAddress, uint256[] memory _orderNonces, address[] memory _destinationAddresses, uint256[] memory _destinationAmounts ) public payable {
        bytes memory payload = abi.encode(messageCode,_orderNonces,_destinationAddresses,_destinationAmounts);
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

    // function _executeWithToken(string calldata sourceChain_, string calldata sourceAddress_, bytes calldata payload, string calldata tokenSymbol, uint256 amount ) internal override {
    function _executeWithToken(string calldata, string calldata, bytes calldata payload, string calldata, uint256 amount ) internal override {
        (uint256 _messageCode, uint256[] memory _orderNonces, address[] memory _destinationAddresses, uint256[] memory _destinationAmounts ) = abi.decode(payload, (uint256,uint256[],address[],uint256[]));

        // receivedAmount_test = amount;
        // recipientNonces = _orderNonces;
        // recipientAddresses_test = _destinationAddresses; 
        // recipientAmounts_test = _destinationAmounts;

        if (_messageCode==4)
        {
           for (uint i=0; i<_orderNonces.length; i++)
           {
                uint engineOrderNonce = _orderNonces[i];
                Orders[engineOrderNonce].IsFinanced = true;
           } //orders in pendingFinancedOrders_FANTOM that have IsFinanced true are ready to be executed
        }

    }

    function _execute(string calldata, string calldata, bytes calldata payload) internal override {
        (uint256 messageCode, uint256[] memory OrderNoncesToDelete) = abi.decode(payload, (uint256,uint256[]));

        if (messageCode==4) //transferFrom axlUSDC from order owners to execute Limit or DCA orders
        {
            for (uint i=0; i< OrderNoncesToDelete.length; i++)
            {
                unfinancedOrderNoncesToDelete.push( OrderNoncesToDelete[i] );
            }
        }
    }

    // Run only if unfinancedOrderNoncesToDelete>0
    function delete_Unfinanced_Orders() external {

        for (uint i=0; i< unfinancedOrderNoncesToDelete.length; i++)
        {
            delete_Order( 1, unfinancedOrderNoncesToDelete[i] );
        }
        delete unfinancedOrderNoncesToDelete;
    }

    function delete_Order(uint whichArray, uint order_nonce) public {
        Order memory del_order = Orders[order_nonce];
        uint elemPos = del_order.positionAr;
        uint updatedElementNonce = 0;

        if (whichArray==1)
        {
            if (elemPos < pendingFinancedOrders_FromFANTOM_USDC.length-1)
            {
                updatedElementNonce = pendingFinancedOrders_FromFANTOM_USDC[pendingFinancedOrders_FromFANTOM_USDC.length-1];
                pendingFinancedOrders_FromFANTOM_USDC[elemPos] = updatedElementNonce;
            }
            pendingFinancedOrders_FromFANTOM_USDC.pop();
        }
        else if (whichArray==2)
        {
            if (elemPos < pendingOrders_FromFANTOM_NON_USDC.length-1)
            {
                updatedElementNonce = pendingOrders_FromFANTOM_NON_USDC[pendingOrders_FromFANTOM_NON_USDC.length-1];
                pendingOrders_FromFANTOM_NON_USDC[elemPos] = updatedElementNonce;
            }
            pendingOrders_FromFANTOM_NON_USDC.pop();
        }
        else if (whichArray==3)
        {
            if (elemPos < pendingOrders_FromFANTOM_USDC.length-1)
            {
                updatedElementNonce = pendingOrders_FromFANTOM_USDC[pendingOrders_FromFANTOM_USDC.length-1];
                pendingOrders_FromFANTOM_USDC[elemPos] = updatedElementNonce;
            }
            pendingOrders_FromFANTOM_USDC.pop();
        }

        if (updatedElementNonce!=0)
        {
            Orders[updatedElementNonce].positionAr = elemPos;
        }
        delete Orders[order_nonce];
    }


    function executeOrder_Moonbeam_BuyWithUSDC(uint orderNonce) public {
        Order memory  ord =  Orders[orderNonce];
        require(ord.tokenIn==USDC_address,"this is only for tokenIn being USDC");  //remember the user has sent axlUSDC
        
        if (ord.IsFinanced)
        {
            if (ord.size > 0)
            {
                
                //swap axlUSDC to USDC
                IERC20(axlUSDC_address).approve(stellaSwapAddress,ord.size);
                uint256 amountOut_USDC = dex.stableSwapExactInput( axlUSDC_address, USDC_address, ord.size );
                IERC20(USDC_address).approve(stellaSwapAddress,amountOut_USDC);

                if (ord.tokenOut==WGLMR_address)
                {
                    uint256 amountOut = dex.swapExactInputSingle(USDC_address,WGLMR_address,amountOut_USDC);
                    userBalance[ord.owner][WGLMR_address] +=amountOut;
                }
                else if (ord.tokenOut==xcDOT_address)
                {
                    uint256 amountOut = dex.swapExactInputMulti3hops(USDC_address,WGLMR_address,xcDOT_address,amountOut_USDC);
                    userBalance[ord.owner][xcDOT_address] +=amountOut;
                }
                else if (ord.tokenOut==xcASTR_address)
                {
                    uint256 amountOut = dex.swapExactInputMulti4hops(USDC_address,WGLMR_address,xcDOT_address,xcASTR_address,amountOut_USDC);
                    userBalance[ord.owner][xcASTR_address] +=amountOut;
                }
            }

            delete_Order(1, orderNonce);
        }

    }


    function executeOrder_Moonbeam_NONUSDC(uint orderNonce) public payable {
        Order memory  ord =  Orders[orderNonce];
        require(ord.tokenIn!=USDC_address,"this is only for tokenIn not being USDC");   
        uint256 amountOut_USDC = 0;

        if (ord.tokenIn==WGLMR_address && userBalance[ord.owner][WGLMR_address] >= ord.size )
        {
            userBalance[ord.owner][WGLMR_address] -= ord.size;
            IERC20(WGLMR_address).approve(stellaSwapAddress,ord.size);
            amountOut_USDC = dex.swapExactInputSingle(WGLMR_address,USDC_address,ord.size);
        }
        else if (ord.tokenIn==xcDOT_address && userBalance[ord.owner][xcDOT_address] >= ord.size)
        {
            userBalance[ord.owner][xcDOT_address] -= ord.size;
            IERC20(xcDOT_address).approve(stellaSwapAddress,ord.size);
            amountOut_USDC = dex.swapExactInputMulti3hops(xcDOT_address,WGLMR_address,USDC_address,ord.size);
        }
        else if (ord.tokenIn==xcASTR_address && userBalance[ord.owner][xcASTR_address] >= ord.size)
        {
            userBalance[ord.owner][xcASTR_address] -= ord.size;
            IERC20(xcASTR_address).approve(stellaSwapAddress,ord.size);
            amountOut_USDC = dex.swapExactInputMulti4hops(xcASTR_address,xcDOT_address,WGLMR_address,USDC_address,ord.size);
        }
        
        //swap USDC for axlUSDC
        if (amountOut_USDC > 0)
        {
            IERC20(USDC_address).approve(stellaSwapAddress,amountOut_USDC);
            uint256 amountOut_axlUSDC = dex.stableSwapExactInput( USDC_address, axlUSDC_address, amountOut_USDC );
            // SEND TO OWNER IN FANTOM
            sendToMany("Fantom",satelite_FantomAddress,5,ord.owner,amountOut_axlUSDC,"axlUSDC",amountOut_axlUSDC);
        }

        delete_Order(2, orderNonce);
    }

    function sendToMany( string memory destinationChain, string memory destinationAddress, uint256 _messageCode, address _ownerAddress, uint256 _ownerAmount, string memory _symbol, uint256 amount) public payable {
        address tokenAddress = gateway.tokenAddresses(_symbol);
        IERC20(tokenAddress).approve(address(gateway), amount);
        bytes memory payload = abi.encode(_messageCode,_ownerAddress,_ownerAmount);

        if (msg.value > 0) {
            gasService.payNativeGasForContractCallWithToken{ value: msg.value }(
                address(this),
                destinationChain,
                destinationAddress,
                payload,
                _symbol,
                amount,
                msg.sender
            );
        }
        gateway.callContractWithToken(destinationChain, destinationAddress, payload, _symbol, amount);
    }


    function get_pendingOrders_FromFANTOM_NON_USDC() external view returns(uint[] memory) {
        return pendingOrders_FromFANTOM_NON_USDC;
    }
    function get_pendingOrders_FromFANTOM_USDC() external view returns(uint[] memory) {
        return pendingOrders_FromFANTOM_USDC;
    }
    function get_pendingFinancedOrders_FromFANTOM_USDC() external view returns(uint[] memory) {
        return pendingFinancedOrders_FromFANTOM_USDC;
    }

    // function getUSERbalance(address account, address tokenAddress) external view returns(uint) {
    //     return userBalance[account][tokenAddress];
    // }
    function get_unfinancedOrderNoncesToDelete() external view returns(uint[] memory) {
        return unfinancedOrderNoncesToDelete;
    }

    //ONLY FOR TESTING
    function getOurTokensOut() external   {
        IERC20(axlUSDC_address).transfer(msg.sender, IERC20(axlUSDC_address).balanceOf(address(this)) );
        // IERC20(USDC_address).transfer(msg.sender, IERC20(USDC_address).balanceOf(address(this)) );
        IERC20(xcDOT_address).transfer(msg.sender, IERC20(xcDOT_address).balanceOf(address(this)) );
        IERC20(WGLMR_address).transfer(msg.sender, IERC20(WGLMR_address).balanceOf(address(this)) );
        // IERC20(xcASTR_address).transfer(msg.sender, IERC20(xcASTR_address).balanceOf(address(this)) );
    }

}