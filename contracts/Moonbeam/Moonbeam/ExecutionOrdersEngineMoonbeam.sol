//SPDX-License-Identifier: MIT
pragma solidity >=0.7.6;

import '../../IERC20.sol';
import './StellaSwap/IStellaSwap.sol';  //1

// USDC => WGLMR => DOT
// USDC => WGLMR
// USDC => WGLMR => DOT => ASTR

contract ExecutionOrdersEngineMoonbeam { 

    address public admin;  
    uint public engine_nonce = 0;

    address public stellaSwapAddress; 
    IStellaSwap public dex; 

    address public constant xcASTR_address = 0xFfFFFfffA893AD19e540E172C10d78D4d479B5Cf;
    address public constant WGLMR_address = 0xAcc15dC74880C9944775448304B263D191c6077F;    //18 decimals
    address public constant xcDOT_address = 0xFfFFfFff1FcaCBd218EDc0EbA20Fc2308C778080;    //10 decimals
    address public constant USDC_address = 0x931715FEE2d06333043d11F658C8CE934aC61D0c;     //6 decimals
    // address public constant axlUSDC_address = 0xCa01a1D0993565291051daFF390892518ACfAD3A;  //6 decimals

    IERC20 public USDC;

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
    }   

    mapping(uint => Order) public Orders;          //for a given noce give the Order details back
    uint[] public pendingOrders_MOONBEAM;

    // mapping(address => uint) public userBalance;        //tokenAddress => balance    

    modifier onlyAdmin {
        require(msg.sender==admin,"action only for admin");
        _;
    }  

    constructor() {
        admin = msg.sender;
        USDC = IERC20(USDC_address);
    }

    function get_pendingOrders_MOONBEAM() external view returns(uint[] memory) {
        return pendingOrders_MOONBEAM;
    }

    // Collects orders that are ready to be send to Exchange
    function addTo_Orders(uint _nonce, address _owner, address tokenIn, address tokenOut, uint limit_price, uint stop_price, uint size, uint block_submitted, uint order_type) external { //to be called only by Authroity Account
        uint positionAr;
        engine_nonce +=1;

        positionAr = pendingOrders_MOONBEAM.length;
        pendingOrders_MOONBEAM.push(engine_nonce);

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
                                positionAr: positionAr
                            });

    } 

    function delete_Order(uint order_nonce) public {
        Order memory del_order = Orders[order_nonce];
        uint elemPos = del_order.positionAr;
        uint updatedElementNonce = 0;

        if (elemPos < pendingOrders_MOONBEAM.length-1)
        {
            updatedElementNonce = pendingOrders_MOONBEAM[pendingOrders_MOONBEAM.length-1];
            pendingOrders_MOONBEAM[elemPos] = updatedElementNonce;
        }
        pendingOrders_MOONBEAM.pop();
   

        if (updatedElementNonce!=0)
        {
            Orders[updatedElementNonce].positionAr = elemPos;
        }
        delete Orders[order_nonce];
    }


    function executeOrder_Moonbeam(uint orderNonce) external {
        Order memory  ord =  Orders[orderNonce];
        
        //execute order and send token to user
        if (ord.tokenIn==USDC_address)
        {
            USDC.transferFrom(ord.owner,address(this),ord.size);
            USDC.approve(stellaSwapAddress,ord.size);

            if (ord.tokenOut==WGLMR_address)
            {
                uint256 amountOut = dex.swapExactInputSingle(USDC_address,WGLMR_address,ord.size);
                IERC20(WGLMR_address).transfer(ord.owner, amountOut);
            }
            else if (ord.tokenOut==xcDOT_address)
            {
                uint256 amountOut = dex.swapExactInputMulti3hops(USDC_address,WGLMR_address,xcDOT_address,ord.size);
                IERC20(xcDOT_address).transfer(ord.owner, amountOut);
            }
            else if (ord.tokenOut==xcASTR_address)
            {
                uint256 amountOut = dex.swapExactInputMulti4hops(USDC_address,WGLMR_address,xcDOT_address,xcASTR_address,ord.size);
                IERC20(xcASTR_address).transfer(ord.owner, amountOut);
            }
        }
        else if (ord.tokenIn==WGLMR_address)
        {
            IERC20(WGLMR_address).transferFrom(ord.owner,address(this),ord.size);
            IERC20(WGLMR_address).approve(stellaSwapAddress,ord.size);
            uint256 amountOut = dex.swapExactInputSingle(WGLMR_address,USDC_address,ord.size);
            USDC.transfer(ord.owner, amountOut);
        }
        else if (ord.tokenIn==xcDOT_address)
        {
            IERC20(xcDOT_address).transferFrom(ord.owner,address(this),ord.size);
            IERC20(xcDOT_address).approve(stellaSwapAddress,ord.size);
            uint256 amountOut = dex.swapExactInputMulti3hops(xcDOT_address,WGLMR_address,USDC_address,ord.size);
            USDC.transfer(ord.owner, amountOut);
        }
        else if (ord.tokenIn==xcASTR_address)
        {
            IERC20(xcASTR_address).transferFrom(ord.owner,address(this),ord.size);
            IERC20(xcASTR_address).approve(stellaSwapAddress,ord.size);
            uint256 amountOut = dex.swapExactInputMulti4hops(xcASTR_address,xcDOT_address,WGLMR_address,USDC_address,ord.size);
            USDC.transfer(ord.owner, amountOut);
        }

        delete_Order(ord.engine_nonce);
    }


    // 0xB7c9423D679A3Da4580e22259362d74099bD1B7C
    function set_StellaSwap(address _stellaSwapAddress) public   {
        stellaSwapAddress = _stellaSwapAddress;
        dex = IStellaSwap(_stellaSwapAddress);
    }


    //ONLY FOR TESTING
    function getOurTokensOut() external   {
        IERC20(USDC_address).transfer(msg.sender, IERC20(USDC_address).balanceOf(address(this)) );
        IERC20(xcDOT_address).transfer(msg.sender, IERC20(xcDOT_address).balanceOf(address(this)) );
        IERC20(WGLMR_address).transfer(msg.sender, IERC20(WGLMR_address).balanceOf(address(this)) );
        IERC20(xcASTR_address).transfer(msg.sender, IERC20(xcASTR_address).balanceOf(address(this)) );
    }

}