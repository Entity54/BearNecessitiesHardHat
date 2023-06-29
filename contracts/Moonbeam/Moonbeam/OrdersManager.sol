//SPDX-License-Identifier: MIT
pragma solidity >=0.7.6;

import './StellaSwap/IStellaSwap.sol';  
import './UsersRegistry.sol';  
import './ExecutionOrdersEngineMoonbeam.sol';  
import './ExecutionOrdersEngineFromFantom.sol';  

   
contract OrdersManager { 

    //FOR SPOOKY SWAP FTM, BOO, MIM, WETH 
    address public admin;  
 
    address public stellaSwapAddress; 
    IStellaSwap public dex; 

    address public executionOrdersEngineMoonbeam_Address;
    ExecutionOrdersEngineMoonbeam public myExecutionOrdersEngineMoonbeam;

    address public executionOrdersEngineFantom_Address;
    ExecutionOrdersEngineFromFantom public myExecutionOrdersEngineFromFantom;

    address public usersRegistry_Address;
    UsersRegistry public myUsersRegistry;

    // address public constant xcINTR_address = 0xFffFFFFF4C1cbCd97597339702436d4F18a375Ab;
    address public constant xcASTR_address = 0xFfFFFfffA893AD19e540E172C10d78D4d479B5Cf;
    address public constant WGLMR_address = 0xAcc15dC74880C9944775448304B263D191c6077F;    //18 decimals
    address public constant xcDOT_address = 0xFfFFfFff1FcaCBd218EDc0EbA20Fc2308C778080;    //10 decimals
    address public constant USDC_address = 0x931715FEE2d06333043d11F658C8CE934aC61D0c;     //6 decimals
    address public constant axlUSDC_address = 0xCa01a1D0993565291051daFF390892518ACfAD3A;  //6 decimals


    uint public nonce = 0;

    struct Order {
        uint      nonce;
        address   owner;
        address   tokenIn;   //USDC
        address   tokenOut;  
        uint      limit_price;
        uint      stop_price;
        uint      size;
        uint      block_submitted;
        uint      numOfsplits;
        uint      order_type;   //1: limit, 2:stop, 3: brackets, 4: DCA
        uint      positionAr;   //where in the Array can I find the nonce of this order Arry can be based on type limitOrdersArray, stopOrdersArray, bracketOrdersArray, dcaOrdersArray
        uint      dcaBlockInterval;
    }   

    mapping(uint => Order) public Orders;          //for a given noce give the Order details back

    uint[] public limitOrdersArray;     //keep hold the nonces of orders that are limite orders
    uint[] public stopOrdersArray;
    uint[] public bracketOrdersArray;
    uint[] public dcaOrdersArray;

    uint[] public orderNoncesToDelete;
    
    //Prices
    mapping(address => uint) public priceUSDC;          // for given tokenAddress tell me the price of it in USDC

    modifier onlyAdmin {
        require(msg.sender==admin,"action only for admin");
        _;
    }  

  
    constructor() { 
        admin = msg.sender;
    }

    //NEED TO APPROVE THE EXECUTION ORDERSENGINE CONTRACT SO IT CAN PULL THE FUNDS WHEN NEEDED. APPROVAL AMOUNT = CURRENT ALLOWANCE  (FROM OTHER ORDERS) + size
    // YOU MUST ENSURE THE USER IS REGISTERED 
    function submit_Order(address _owner, address tokenIn, address tokenOut, uint limit_price, uint stop_price, uint size, uint num_Ofsplits, uint order_type, uint _dcaBlockInterval ) external {
        require(myUsersRegistry.isUserRegistered(_owner),"user is not registered. Register user first at UsersRegistry"); 
        // require(myExecutionOrdersEngine.isUserRegistered(_owner),"user is not registered. Register user first at ExecutionOrdersEngine"); 
        // require(isUserRegistered[_owner],"user is not registered. Register user first");

        uint limitPrice = 0;
        uint stopPrice = 0;
        uint numOfsplits=0;
        uint positionAr=0;

        if (order_type==1)
        {
            limitPrice = limit_price;
            positionAr = limitOrdersArray.length;
        }
        else if (order_type==2)
        {
            stopPrice = stop_price;
            positionAr = stopOrdersArray.length;
        }
        else if (order_type==3)
        {
            limitPrice = limit_price;
            stopPrice = stop_price;
            positionAr = bracketOrdersArray.length;
        }
        else if (order_type==4)
        {
            numOfsplits = num_Ofsplits;
            positionAr = dcaOrdersArray.length;
        }
 
        nonce +=1;
        Order memory newOrder = Order({ 
                                nonce: nonce, 
                                owner: _owner,
                                tokenIn: tokenIn,
                                tokenOut: tokenOut,
                                limit_price: limitPrice,
                                stop_price: stopPrice,
                                size: size,
                                block_submitted: block.number,
                                numOfsplits: numOfsplits,
                                order_type: order_type,
                                positionAr: positionAr,
                                dcaBlockInterval: _dcaBlockInterval
                            });

        if (order_type==1)
        {
            limitOrdersArray.push(newOrder.nonce);
        }
        else if (order_type==2)
        {
            stopOrdersArray.push(newOrder.nonce);
        }
        else if (order_type==3)
        {
            bracketOrdersArray.push(newOrder.nonce);
        }
        else if (order_type==4)
        {
            dcaOrdersArray.push(newOrder.nonce);
        }
        Orders[nonce] = newOrder;
        
    }
  

    function delete_Order(uint order_nonce) public {
        Order memory del_order = Orders[order_nonce];
        uint ordType = del_order.order_type;
        uint elemPos = del_order.positionAr;
        uint updatedElementNonce = 0;

        if (ordType == 1)
        {
            if (elemPos < limitOrdersArray.length-1)
            {
                updatedElementNonce = limitOrdersArray[limitOrdersArray.length-1];
                limitOrdersArray[elemPos] = updatedElementNonce;
            }
            limitOrdersArray.pop();
        }
        else if (ordType == 2)
        {
            if (elemPos < stopOrdersArray.length-1)
            {
                updatedElementNonce = stopOrdersArray[stopOrdersArray.length-1];
                stopOrdersArray[elemPos] = updatedElementNonce;
            }
            stopOrdersArray.pop();
        }
        else if (ordType == 3)
        {
            if (elemPos < bracketOrdersArray.length-1)
            {
                updatedElementNonce = bracketOrdersArray[bracketOrdersArray.length-1];
                bracketOrdersArray[elemPos] = updatedElementNonce;
            }
            bracketOrdersArray.pop();
        }
        else if (ordType == 4)
        {
            if (elemPos < dcaOrdersArray.length-1)
            {
                updatedElementNonce = dcaOrdersArray[dcaOrdersArray.length-1];
                dcaOrdersArray[elemPos] = updatedElementNonce;
            }
            dcaOrdersArray.pop();
        }

        if (updatedElementNonce!=0)
        {
            Orders[updatedElementNonce].positionAr = elemPos;
        }
        delete Orders[order_nonce];
    }

    function delete_OrdersArray() public {
        if (orderNoncesToDelete.length > 0)
        {
            for (uint i=0; i<orderNoncesToDelete.length; i++)
            {
                delete_Order( orderNoncesToDelete[i] ); 
            }
            delete orderNoncesToDelete;
        }
    }

    function get_StellaSwapPrice() external {
        // priceUSDC[xcDOT_address]  =  dex.getPrice_token1HopsUSDC_WEI(xcDOT_address,1000000);
        // priceUSDC[WGLMR_address]  =  dex.getPrice_token1USDC_WEI(WGLMR_address,1000000);
        // priceUSDC[xcASTR_address] =  dex.getPrice_token1HopsUSDC_WEI(xcASTR_address,1000000);
        priceUSDC[xcDOT_address]  =  dex.getTokenPriceUSDCwei_1Hops(xcDOT_address,10000000000);
        priceUSDC[WGLMR_address]  =  dex.getTokenPriceUSDCwei(WGLMR_address,1000000000000000000);
        priceUSDC[xcASTR_address] =  dex.getTokenPriceUSDCwei_1Hops(xcASTR_address,1000000000000000000);
    }

    function transmitOrderToExecutionEngine(uint _nonce, address _owner, address _tokenIn, address _tokenOut, uint _limit_price, uint _stop_price, uint _size, uint _block_submitted, uint _order_type) internal {
        string memory userChain =  myUsersRegistry.getUserChain(_owner);
        if (keccak256(bytes(userChain)) == keccak256(bytes("MOONBEAM")) )
        {
            myExecutionOrdersEngineMoonbeam.addTo_Orders(_nonce, _owner, _tokenIn, _tokenOut, _limit_price, _stop_price, _size, _block_submitted, _order_type); 
        }
        else if (keccak256(bytes(userChain)) == keccak256(bytes("FANTOM")) )
        {
            myExecutionOrdersEngineFromFantom.addTo_Orders(_nonce, _owner, _tokenIn, _tokenOut, _limit_price, _stop_price, _size, _block_submitted, _order_type); 
        }
    }

    function checkLimitOrders() external {
        for (uint i=0; i<limitOrdersArray.length; i++)
        {
            Order memory ord = Orders[ limitOrdersArray[i] ];
            if (ord.tokenIn==USDC_address)
            {
                if ( priceUSDC[ord.tokenOut] < ord.limit_price)
                {
                    transmitOrderToExecutionEngine(ord.nonce, ord.owner, ord.tokenIn, ord.tokenOut, ord.limit_price, ord.stop_price, ord.size, ord.block_submitted, ord.order_type); 
                    orderNoncesToDelete.push( ord.nonce );
                } 
            }
        }
        delete_OrdersArray();
    }

    function checkStopOrders() external {
        for (uint i=0; i<stopOrdersArray.length; i++)
        {
            Order memory ord = Orders[ stopOrdersArray[i] ];
            if (ord.tokenOut==USDC_address)
            {
                if ( priceUSDC[ord.tokenIn] < ord.stop_price)
                {
                    transmitOrderToExecutionEngine(ord.nonce, ord.owner, ord.tokenIn, ord.tokenOut, ord.limit_price, ord.stop_price, ord.size, ord.block_submitted, ord.order_type); 
                    orderNoncesToDelete.push( ord.nonce );
                } 
            }
        }
        delete_OrdersArray();
    }

    function checkBracketOrders() external {
        for (uint i=0; i<bracketOrdersArray.length; i++)
        {
            Order memory ord = Orders[ bracketOrdersArray[i] ];
            if (ord.tokenOut==USDC_address)
            {
                if ( priceUSDC[ord.tokenIn] < ord.stop_price || priceUSDC[ord.tokenIn] > ord.limit_price)
                {
                    transmitOrderToExecutionEngine(ord.nonce, ord.owner, ord.tokenIn, ord.tokenOut, ord.limit_price, ord.stop_price, ord.size, ord.block_submitted, ord.order_type); 
                    orderNoncesToDelete.push( ord.nonce );
                } 
            }
        }
        delete_OrdersArray();
    }
 
    function checkDCAOrders() external {
        for (uint i=0; i<dcaOrdersArray.length; i++)
        {
            uint orderNonce = dcaOrdersArray[i];
            Order memory ord = Orders[ orderNonce ];
            if (ord.tokenIn==USDC_address)
            {
                if ( block.number > (ord.block_submitted + ord.dcaBlockInterval) )
                {
                    transmitOrderToExecutionEngine(ord.nonce, ord.owner, ord.tokenIn, ord.tokenOut, ord.limit_price, ord.stop_price, ord.size, ord.block_submitted, ord.order_type); 
                    
                    if (ord.numOfsplits==1 )
                    {
                        orderNoncesToDelete.push( ord.nonce );
                    }
                    else 
                    {
                        Orders[ orderNonce ].numOfsplits -=1;
                        Orders[ orderNonce ].block_submitted = block.number;
                    }

                } 
            }
        }
        delete_OrdersArray();
    }


    // 0xB7c9423D679A3Da4580e22259362d74099bD1B7C 
    function set_StellaSwap(address _stellaSwapAddress) public   {
        stellaSwapAddress = _stellaSwapAddress;
        dex = IStellaSwap(_stellaSwapAddress);
    }
    function set_ExecutionOrdersEngineMoonbeam_address(address _executionOrdersEngineAddress) public   { 
        executionOrdersEngineMoonbeam_Address = _executionOrdersEngineAddress;
        myExecutionOrdersEngineMoonbeam = ExecutionOrdersEngineMoonbeam(_executionOrdersEngineAddress);
    }
    function set_ExecutionOrdersEngineFantom_address(address _executionOrdersEngineAddress) public   { 
        executionOrdersEngineFantom_Address = _executionOrdersEngineAddress;
        myExecutionOrdersEngineFromFantom = ExecutionOrdersEngineFromFantom(_executionOrdersEngineAddress);
    }
    function set_UsersRegistry_address(address _usersRegistry_Address) public   { 
        usersRegistry_Address = _usersRegistry_Address;
        myUsersRegistry = UsersRegistry(_usersRegistry_Address);
    }

    function get_limitOrdersArray() external view returns(uint[] memory) {
        return limitOrdersArray;
    }
    function get_stopOrdersArray() external view returns(uint[] memory) {
        return stopOrdersArray;
    }
    function get_bracketOrdersArray() external view returns(uint[] memory) {
        return bracketOrdersArray;
    }
    function get_dcaOrdersArray() external view returns(uint[] memory) {
        return dcaOrdersArray;
    }

  
    //ONLY FOR TESTING
    function set_artifical_StellaSwapPrice(uint dotUSDC, uint wglmrUSDC, uint astrUSDC) external {
        priceUSDC[xcDOT_address]  =  dotUSDC;
        priceUSDC[WGLMR_address]  =  wglmrUSDC;
        priceUSDC[xcASTR_address] =  astrUSDC;
    }

}