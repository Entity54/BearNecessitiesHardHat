//SPDX-License-Identifier: MIT
pragma solidity >=0.7.6;
pragma abicoder v2;
 
import './IERC20.sol';
import './ISwapRouter.sol';
import './IStableSwap.sol';
import './IStellaSwapQuoter.sol';
 
 
contract StellaSwap {
    address public constant USDC_address = 0x931715FEE2d06333043d11F658C8CE934aC61D0c;     //6 decimals
    address public constant WGLMR_address = 0xAcc15dC74880C9944775448304B263D191c6077F;    //18 decimals
    address public constant xcDOT_address = 0xFfFFfFff1FcaCBd218EDc0EbA20Fc2308C778080;    //10 decimals
    address public constant xcINTR_address = 0xFffFFFFF4C1cbCd97597339702436d4F18a375Ab;   //10 decimals
    address public constant xcASTR_address = 0xFfFFFfffA893AD19e540E172C10d78D4d479B5Cf;   //18 decimals
    address public constant axlUSDC_address = 0xCa01a1D0993565291051daFF390892518ACfAD3A;  //6 decimals

    address public constant routerAddress = 0xe6d0ED3759709b743707DcfeCAe39BC180C981fe;
    address public constant axlUSDCUSDC_Address = 0x95953409374e1ed252c6D100E7466E346E3dC5b9;
    address public constant stellaSwapQuoter_Address = 0xCF6fb88ac742aB896595705816079c360c590DE5;

    ISwapRouter public immutable swapRouter = ISwapRouter(routerAddress);
    IStableSwap public immutable axlUSDCUSDC = IStableSwap(axlUSDCUSDC_Address);
    IStellaSwapQuoter public immutable priceQuoter = IStellaSwapQuoter(stellaSwapQuoter_Address);
     
    uint public lastSwappedAmount;   //helper you can remove this

    uint256 public gross_price;
    uint256 public totalFees;
    uint256 public totalCost;
    uint256 public finalPrice;

 
    constructor() {} 

    function getBlockTimestamp() external view returns(uint256) {
        return block.timestamp;
    }
  

// 0xFfFFfFff1FcaCBd218EDc0EbA20Fc2308C778080,1000000    DOT for 1 USDC
// 0xFffFFFFF4C1cbCd97597339702436d4F18a375Ab,1000000   503061158235  50.30 INTR for 1 USDC
// 0xFfFFFfffA893AD19e540E172C10d78D4d479B5Cf,1000000   20374710455247099687  20.37 ASTR for 1 USDC
    function getPrice_token1HopsUSDC_WEI(address inputToken, uint256 amountOut) external returns (uint256) {
        bytes memory path;

        if (inputToken==xcINTR_address)
        {
            path = abi.encodePacked(USDC_address, WGLMR_address, xcINTR_address);
        }
        else if (inputToken==xcASTR_address)
        {
            path = abi.encodePacked(USDC_address, WGLMR_address, xcDOT_address, xcASTR_address);
        }
        else if (inputToken==xcDOT_address)
        {
            path = abi.encodePacked(USDC_address, WGLMR_address, xcDOT_address);
        }

        (uint256 amountIn, uint16[] memory fees) = priceQuoter.quoteExactOutput(path,amountOut);

        // gross_price = amountIn;        //FOR TESTING
        
        // uint256 sumOfFees = 0;
        // if (fees.length>0)
        // {
        //     for (uint i = 0; i < fees.length; i++) 
        //     {
        //         sumOfFees +=fees[i];
        //     }
        // }
        // totalFees = sumOfFees;
        // totalCost = amountIn + totalFees;
        // finalPrice = (totalCost * 101)/100 ;
        // return finalPrice;

        return amountIn;
    }


// 0xFfFFfFff1FcaCBd218EDc0EbA20Fc2308C778080,10000000000           1 DOT for X USDC     4840320 or 4.84 USDC for 1 DOT
// 0xFffFFFFF4C1cbCd97597339702436d4F18a375Ab,10000000000           1 INTR for X USDC    18796   or 0.018796 USDC for 1 INTR
// 0xFfFFFfffA893AD19e540E172C10d78D4d479B5Cf,1000000000000000000   1 ASTR for X USDC    45650   or 0.045650 USDC for 1 ASTR
    function getTokenPriceUSDCwei_1Hops(address inputToken, uint256 amountIn) external returns (uint256) {
        bytes memory path;

        if (inputToken==xcINTR_address)
        {
            path = abi.encodePacked(xcINTR_address, WGLMR_address, USDC_address);
        }
        else if (inputToken==xcASTR_address)
        {
            path = abi.encodePacked(xcASTR_address, xcDOT_address, WGLMR_address, USDC_address);
        }
        else if (inputToken==xcDOT_address)
        {
            path = abi.encodePacked(xcDOT_address, WGLMR_address, USDC_address);
        }

        (uint256 amountOut, uint16[] memory fees) = priceQuoter.quoteExactInput(path,amountIn);

        // gross_price = amountOut; //FOR TESTING

        return amountOut;
    }
 
// 0xAcc15dC74880C9944775448304B263D191c6077F,1000000 for How many WGLMR for 1 USDC.e.g. 3516777802261008265 WGLMR 1000000 USDC
    function getPrice_token1USDC_WEI(address inputToken, uint256 amountOut) external returns (uint256) {
        (uint256 amountIn, uint16 fee) = priceQuoter.quoteExactOutputSingle(inputToken,USDC_address,amountOut,0);

        // gross_price = amountIn;   //FOR TESTING
        // totalFees = fee;
        // totalCost = amountIn + totalFees;
        // finalPrice = totalCost;
        // return finalPrice;

        return amountIn;
    }

// 0xAcc15dC74880C9944775448304B263D191c6077F,1000000000000000000 for How many USDC for 1 WGLMR 265719 or 0.265719 USDC for 1 WGLMR  
    function getTokenPriceUSDCwei(address inputToken, uint256 amountIn) external returns (uint256) {
        (uint256 amountOut, uint16 fee) = priceQuoter.quoteExactInputSingle(inputToken,USDC_address,amountIn,0);
        // gross_price = amountOut; //FOR TESTING
        return amountOut;
    }


// USDC,axlUSDC,amountUSDC,minimumAmount=0,Blocktimestmp+something for deadline. 6 decimals. 1 USDC
// 1,0,12000,0,1685908528
// 0x931715FEE2d06333043d11F658C8CE934aC61D0c,0xCa01a1D0993565291051daFF390892518ACfAD3A,1000000

// axlUSDC,USDC,amount_axlSUDC,1       axlSUSDC
// 0,1,110000,0,1685908912   
// 0xCa01a1D0993565291051daFF390892518ACfAD3A,0x931715FEE2d06333043d11F658C8CE934aC61D0c,1000000

    function stableSwapExactInput(address inputTokenAddress, address outputTokenAddress, uint256 amountIn) external payable returns (uint256 amountOut) {
        
        IERC20 inputToken = IERC20(inputTokenAddress);   
        IERC20 outputToken = IERC20(outputTokenAddress);   
        
        uint8 tokenIndexFrom;
        uint8 tokenIndexTo;
        uint256 dx = amountIn;
        uint256 minDy = 0;
        uint256 deadline = block.timestamp + 60000;

        if (inputTokenAddress==axlUSDC_address && outputTokenAddress==USDC_address)
        {
            tokenIndexFrom = 0;
            tokenIndexTo = 1;
        }
        else if (inputTokenAddress==USDC_address && outputTokenAddress==axlUSDC_address) {
            tokenIndexFrom = 1;
            tokenIndexTo = 0;
        }
        else {
            revert("token addresses are not correct for this pool");
        }

        // Transfer the specified amount of Token to this contract.
        inputToken.transferFrom(msg.sender, address(this), amountIn);

        // Approve the router to spend USDC.
        inputToken.approve(axlUSDCUSDC_Address, amountIn);

        amountOut = axlUSDCUSDC.swap(tokenIndexFrom,tokenIndexTo,dx,minDy,deadline);
        outputToken.transfer(msg.sender,amountOut);
        lastSwappedAmount = amountOut;
    }



//TRADES
// WGLMR,USDC,amount. 0.1 WGLMR 18 decimals
// 0xAcc15dC74880C9944775448304B263D191c6077F,0x931715FEE2d06333043d11F658C8CE934aC61D0c,100000000000000000
// USDC,WGLMR,amount 0.1 USDC 6 decimals
// 0x931715FEE2d06333043d11F658C8CE934aC61D0c,0xAcc15dC74880C9944775448304B263D191c6077F,100000

// ASTR,DOT,amount 1 ASTR 18 decimals
// 0xFfFFFfffA893AD19e540E172C10d78D4d479B5Cf,0xFfFFfFff1FcaCBd218EDc0EbA20Fc2308C778080,1000000000000000000
// DOT,ASTR,amount 0.001 DOT 10 decimals 
// 0xFfFFfFff1FcaCBd218EDc0EbA20Fc2308C778080,0xFfFFFfffA893AD19e540E172C10d78D4d479B5Cf,1000000

// INTR,WGLMR,amount 1 INTR 10 decimals
// 0xFffFFFFF4C1cbCd97597339702436d4F18a375Ab,0xAcc15dC74880C9944775448304B263D191c6077F,10000000000
// WGLMR,INTR,amount 0.001 DOT 10 decimals
// 0xAcc15dC74880C9944775448304B263D191c6077F,0xFffFFFFF4C1cbCd97597339702436d4F18a375Ab,100000000000000000

// DOT,GLMR 0.001 DOT 10 decimals 
// 0xFfFFfFff1FcaCBd218EDc0EbA20Fc2308C778080,0xAcc15dC74880C9944775448304B263D191c6077F,10000000
// GLMR,DOT 0.1 GLMR 18 decimals 
// 0xAcc15dC74880C9944775448304B263D191c6077F,0xFfFFfFff1FcaCBd218EDc0EbA20Fc2308C778080,100000000000000000

// INTR => GLMR => USDC => axlUSDC
// ASTR -> DOT =>  GLMR => USDC => axlUSDC

// axlUSDC,USDC, 0.1 axlUSDC 6 decimals
// 0xCa01a1D0993565291051daFF390892518ACfAD3A,0x931715FEE2d06333043d11F658C8CE934aC61D0c,170118  //2701188

    /// msg.sender must approve this contract
    function swapExactInputSingle(address inputTokenAddress, address outputTokenAddress, uint256 amountIn) external payable returns (uint256 amountOut) {
        IERC20 inputToken = IERC20(inputTokenAddress);   
         
        // Transfer the specified amount of Token to this contract.
        inputToken.transferFrom(msg.sender, address(this), amountIn);

        // Approve the router to spend USDC.
        inputToken.approve(address(swapRouter), amountIn);

        ISwapRouter.ExactInputSingleParams memory params =
            ISwapRouter.ExactInputSingleParams({
                tokenIn: inputTokenAddress,
                tokenOut: outputTokenAddress,
                // fee: poolFee,
                recipient: msg.sender,
                deadline: block.timestamp + 60000,
                amountIn: amountIn,
                amountOutMinimum: 0,
                limitSqrtPrice: 0
            });

        amountOut = swapRouter.exactInputSingle(params);
        lastSwappedAmount = amountOut;
    }


//Example 
// xcINTR,WGLMR,USDC 10 INTR 10 decimals 10000000000
// 0xFffFFFFF4C1cbCd97597339702436d4F18a375Ab,0xAcc15dC74880C9944775448304B263D191c6077F,0x931715FEE2d06333043d11F658C8CE934aC61D0c,100000000000
// USDC,WGLMR,xcINTR 1 USDC 6 decimals 1000000
// 0x931715FEE2d06333043d11F658C8CE934aC61D0c,0xAcc15dC74880C9944775448304B263D191c6077F,0xFffFFFFF4C1cbCd97597339702436d4F18a375Ab,1000000

// xcDOT,WGLMR,USDC 0.1 xcDOT 6 decimals 10000000000
// 0xFfFFfFff1FcaCBd218EDc0EbA20Fc2308C778080,0xAcc15dC74880C9944775448304B263D191c6077F,0x931715FEE2d06333043d11F658C8CE934aC61D0c,10000000000
// USDC,WGLMR,xcDOT 0.1 USDC 6 decimals 100000
// 0x931715FEE2d06333043d11F658C8CE934aC61D0c,0xAcc15dC74880C9944775448304B263D191c6077F,0xFfFFfFff1FcaCBd218EDc0EbA20Fc2308C778080,100000

    /// msg.sender must approve this contract
    function swapExactInputMulti3hops(address inputTokenAddress, address hopTokenAddress, address outputTokenAddress, uint256 amountIn) external payable returns (uint256 amountOut) {
        IERC20 inputToken = IERC20(inputTokenAddress);   
         
        // Transfer the specified amount of Token to this contract.
        inputToken.transferFrom(msg.sender, address(this), amountIn);

        // Approve the router to spend USDC.
        inputToken.approve(address(swapRouter), amountIn);

        ISwapRouter.ExactInputParams memory params =
            ISwapRouter.ExactInputParams({
                path: abi.encodePacked(inputTokenAddress, hopTokenAddress, outputTokenAddress),
                recipient: msg.sender,
                deadline: block.timestamp + 60000,
                amountIn: amountIn,
                amountOutMinimum: 0
            });

        amountOut = swapRouter.exactInput(params);
        lastSwappedAmount = amountOut;
    }


//Example 
// xcASTR,xcDOT,WGLMR,USDC 1 xcASTR 18 decimals
// 0xFfFFFfffA893AD19e540E172C10d78D4d479B5Cf,0xFfFFfFff1FcaCBd218EDc0EbA20Fc2308C778080,0xAcc15dC74880C9944775448304B263D191c6077F,0x931715FEE2d06333043d11F658C8CE934aC61D0c,1000000000000000000
// USDC,WGLMR,xcDOT,xcASTR 1 USDC 6 decimals
// 0x931715FEE2d06333043d11F658C8CE934aC61D0c,0xAcc15dC74880C9944775448304B263D191c6077F,0xFfFFfFff1FcaCBd218EDc0EbA20Fc2308C778080,0xFfFFFfffA893AD19e540E172C10d78D4d479B5Cf,1000000
    /// msg.sender must approve this contract. 
    function swapExactInputMulti4hops(address inputTokenAddress, address hopTokenAddress1, address hopTokenAddress2, address outputTokenAddress, uint256 amountIn) external payable returns (uint256 amountOut) {
        IERC20 inputToken = IERC20(inputTokenAddress);   
         
        // Transfer the specified amount of Token to this contract.
        inputToken.transferFrom(msg.sender, address(this), amountIn);

        // Approve the router to spend USDC.
        inputToken.approve(address(swapRouter), amountIn);

        ISwapRouter.ExactInputParams memory params =
            ISwapRouter.ExactInputParams({
                path: abi.encodePacked(inputTokenAddress, hopTokenAddress1, hopTokenAddress2, outputTokenAddress),
                recipient: msg.sender,
                deadline: block.timestamp + 60000,
                amountIn: amountIn,
                amountOutMinimum: 0
            });

        amountOut = swapRouter.exactInput(params);
        lastSwappedAmount = amountOut;
    }

}