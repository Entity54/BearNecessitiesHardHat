// npx hardhat run scripts/uj_OrdersManager.js
// or npx hardhat run --network <your-network> scripts/uj_OrdersManager.js
// npx hardhat run --network Moonbase scripts/uj_OrdersManager.js

// npx hardhat run --network Moonbeam scripts/uj_OrdersManager.js

 
//***** Smart Contract Address *****/
/// MOONBASE ALPHA
// // const delArrayElement_address = "0x8a9de54A7007a5811fC3C4Fde1fE7a230EbF36e6";   
// const ordersManager_address = "0x1374443BA8451ab11D5778C08dB7b32b92B945AF";
// const usersRegistry_address = "0x70388FDc83f5D1f69Dd6595112366C0e578CcEe5";
// const executionOrdersEngineMoonbeam_address = "0x05c8ff63cC0dd09B3043b055f5B21B6D5E2Ed588";


// MOONBEAM
const ordersManager_address = "0x3357e0d9d3eF81Bc6b158313416de8879F2EDcF6";  //"0x9331d7e0F7deD78a21d6A3d381cdc95Da689AF79";
const usersRegistry_address = "0xC11029E655456618bC9FaDFF92B52D99863A9A55";
const executionOrdersEngineMoonbeam_address = "0xce47EE729055A6EF5CCe58B2a319ed8035B90Dcf";

const executionOrdersEngineFromFantom_address = "0xc259A95E717ccf5aEDA5971CE967E528Fa624Bc4";
const axelarMoonbeamSatelite_address = "0xb85E1D77d6430bBDAF91845181440407c3c2bf6b";

//FANTOM SEE uj_AxelarFantomSatelite.js
const axelarFantomSatelite_address = "0x4Ff100bc3b2f40F9F2AF03D095b1Bc5875538321"; //"0x27d7222AD292d017C6eE1f0B8043Da7F4424F6a0";


const stellaSwap_address = "0xF7aC2a2AdEaA1EFc0Bd4130F5a28AE73A1225663";

const xcASTR_address  = "0xFfFFFfffA893AD19e540E172C10d78D4d479B5Cf";
const WGLMR_address   = "0xAcc15dC74880C9944775448304B263D191c6077F";    //18 decimals
const xcDOT_address   = "0xFfFFfFff1FcaCBd218EDc0EbA20Fc2308C778080";    //10 decimals
const USDC_address    = "0x931715FEE2d06333043d11F658C8CE934aC61D0c";    //6 decimals
const axlUSDC_address = "0xCa01a1D0993565291051daFF390892518ACfAD3A";    //6 decimals
//*****/

//***** Smart Contract ABIs *****/
const OrdersManager_JSON = require("../artifacts/contracts/Moonbeam/Moonbeam/OrdersManager.sol/OrdersManager.json");
const UsersRegistry_JSON = require("../artifacts/contracts/Moonbeam/Moonbeam/UsersRegistry.sol/UsersRegistry.json");
const ExecutionOrdersEngineMoonbeam_JSON = require("../artifacts/contracts/Moonbeam/Moonbeam/ExecutionOrdersEngineMoonbeam.sol/ExecutionOrdersEngineMoonbeam.json");

const ExecutionOrdersEngineFromFantom_JSON = require("../artifacts/contracts/Moonbeam/Moonbeam/ExecutionOrdersEngineFromFantom.sol/ExecutionOrdersEngineFromFantom.json");
const AxelarMoonbeamSatelite_JSON = require("../artifacts/contracts/Moonbeam/Moonbeam/AxelarMoonbeamSatelite.sol/AxelarMoonbeamSatelite.json");
//*****/


const { Contract, BigNumber } = require("ethers");
const { formatUnits, parseUnits } = require("ethers/lib/utils");
// const hre = require("hardhat");
// const lockedAmount = hre.ethers.utils.parseEther("0.001");
// ethers.utils.formatEther(lockedAmount);


async function main() {

console.log(`********************************************************`);
console.log(`********************* Getting signers ***********************************`);
const [admin, alice] = await ethers.getSigners();
const adminAddress = await admin.getAddress();
const aliceAddress = await alice.getAddress();
console.log(`Address of the admin is: ${adminAddress} alice: ${aliceAddress}`);
console.log("");
console.log("");

console.log(`********************* Instantiating smart contracts ***********************************`);
const OrdersManager_instance  = new Contract(ordersManager_address, OrdersManager_JSON.abi, admin);
const UsersRegistry_instance = new Contract(usersRegistry_address, UsersRegistry_JSON.abi, admin);
const ExecutionOrdersEngineMoonbeam_instance = new Contract(executionOrdersEngineMoonbeam_address, ExecutionOrdersEngineMoonbeam_JSON.abi, admin);
const ExecutionOrdersEngineFromFantom_instance = new Contract(executionOrdersEngineFromFantom_address, ExecutionOrdersEngineFromFantom_JSON.abi, admin);

const AxelarMoonbeamSatelite_instance = new Contract(axelarMoonbeamSatelite_address, AxelarMoonbeamSatelite_JSON.abi, admin);


console.log(`OrdersManager_instance.address: ${OrdersManager_instance.address} UsersRegistry_instance.address: ${UsersRegistry_instance.address} ExecutionOrdersEngineMoonbeam_instance.address: ${ExecutionOrdersEngineMoonbeam_instance.address} ExecutionOrdersEngineFromFantom_instance.address: ${ExecutionOrdersEngineFromFantom_instance.address}`);
console.log("");
console.log("");


console.log(`********************* OrdersManager_instance ***********************************`);
const admin_of_OrdersManager_instance =  await OrdersManager_instance.admin();
let executionOrdersEngineMoonbeam_Address =  await OrdersManager_instance.executionOrdersEngineMoonbeam_Address();
let stellaSwap_addressof_OrdersManager_instance =  await OrdersManager_instance.stellaSwapAddress();
console.log(`admin_of_OrdersManager_instance: ${admin_of_OrdersManager_instance} executionOrdersEngineMoonbeam_Address: ${executionOrdersEngineMoonbeam_Address} stellaSwap_addressof_OrdersManager_instance: ${stellaSwap_addressof_OrdersManager_instance}`);



    console.log(`********************* Setting Up SC Start ***********************************`);

        console.log(`********************* OrdersManager_instance Setting Up Start ***********************************`);
        // // UNCOMMENT AND RUN IF SETTING UP FOR FIRST TIME
        // const tx_set_UsersRegistry_address =  await OrdersManager_instance.set_UsersRegistry_address(usersRegistry_address);
        // tx_set_UsersRegistry_address.wait().then( async reslveMsg => {
        // 	 console.log(`tx_set_UsersRegistry_address is mined resolveMsg : `,reslveMsg);
        // });
        // const tx_set_ExecutionOrdersEngineMoonbeam_address =  await OrdersManager_instance.set_ExecutionOrdersEngineMoonbeam_address(executionOrdersEngineMoonbeam_address);
        // tx_set_ExecutionOrdersEngineMoonbeam_address.wait().then( async reslveMsg => {
        // 	 console.log(`tx_set_ExecutionOrdersEngineMoonbeam_address is mined resolveMsg : `,reslveMsg);
        // });
        // const tx_set_StellaSwap =  await OrdersManager_instance.set_StellaSwap(stellaSwap_address);
        // tx_set_StellaSwap.wait().then( async reslveMsg => {
        // 	 console.log(`tx_set_StellaSwap is mined resolveMsg : `,reslveMsg);
        // });
        // const tx_set_ExecutionOrdersEngineFantom_address =  await OrdersManager_instance.set_ExecutionOrdersEngineFantom_address(executionOrdersEngineFromFantom_address);
        // tx_set_ExecutionOrdersEngineFantom_address.wait().then( async reslveMsg => {
        // 	 console.log(`tx_set_ExecutionOrdersEngineFantom_address is mined resolveMsg : `,reslveMsg);
        // });
        console.log(`********************* OrdersManager_instance Setting Up End ***********************************`);
        console.log("");
        console.log("");

    
    
    
        console.log(`********************* ExecutionOrdersEngineMoonbeam_instance Setting Up Start ***********************************`);
        // // UNCOMMENT AND RUN IF SETTING UP FOR FIRST TIME
        // const tx_set_StellaSwap2 =  await ExecutionOrdersEngineMoonbeam_instance.set_StellaSwap(stellaSwap_address);
        // tx_set_StellaSwap2.wait().then( async reslveMsg => {
        // 	 console.log(`tx_set_StellaSwap2 is mined resolveMsg : `,reslveMsg);
        // });


            // console.log(`********************* ExecutionOrdersEngineMoonbeam_instance ***********************************`);
            // const admin_of_ExecutionOrdersEngineMoonbeam_instance =  await ExecutionOrdersEngineMoonbeam_instance.admin();
            // let stellaSwap_addressof_ExecutionOrdersEngineMoonbeam_instance =  await ExecutionOrdersEngineMoonbeam_instance.stellaSwapAddress();
            // console.log(`admin_of_ExecutionOrdersEngineMoonbeam_instance: ${admin_of_ExecutionOrdersEngineMoonbeam_instance} stellaSwap_addressof_ExecutionOrdersEngineMoonbeam_instance: ${stellaSwap_addressof_ExecutionOrdersEngineMoonbeam_instance}`);
        console.log(`********************* ExecutionOrdersEngineMoonbeam_instance Setting Up End ***********************************`);
        console.log("");
        console.log("");


        console.log(`********************* UsersRegistry_instance REGISTER USER ***********************************`);
        // let tx_register_user, userStruct;
        // tx_register_user =  await UsersRegistry_instance.registerUser( adminAddress, adminAddress, "MOONBEAM", adminAddress, "01f0f4360fc5dbb8cd7107edf24fc3f3c9ef3914b32585062bfd7aa84e02f8b84e00");
        // tx_register_user.wait().then( async reslveMsg => {
        //     console.log(`tx_register_user is mined resolveMsg : `,reslveMsg);

        //     userStruct =  await UsersRegistry_instance.users(adminAddress);
        //     isUserRegistered =  await UsersRegistry_instance.isUserRegistered(adminAddress);
        //     console.log(`isUserRegistered: ${isUserRegistered} userStruct: `,userStruct);
        //     // isUserRegistered: true userStruct:  [
        //     //     '0x8aC171C7BEa586d84C166BECdd6284B05A682000',
        //     //     '0x8aC171C7BEa586d84C166BECdd6284B05A682000',
        //     //     'MOONBEAM',
        //     //     '0x8aC171C7BEa586d84C166BECdd6284B05A682000',
        //     //     '01f0f4360fc5dbb8cd7107edf24fc3f3c9ef3914b32585062bfd7aa84e02f8b84e00',
        //     //     userEVMAddress: '0x8aC171C7BEa586d84C166BECdd6284B05A682000',
        //     //     userEVMAddressString: '0x8aC171C7BEa586d84C166BECdd6284B05A682000',
        //     //     userChain: 'MOONBEAM',
        //     //     userSubstrateAddressString: '0x8aC171C7BEa586d84C166BECdd6284B05A682000',
        //     //     usererHex: '01f0f4360fc5dbb8cd7107edf24fc3f3c9ef3914b32585062bfd7aa84e02f8b84e00'
        //     //   ]
        // });
        console.log("");
        console.log("");

        console.log(`********************* AxelarMoonbeamSatelite_instance Setting Up Start ***********************************`);
        // // UNCOMMENT AND RUN IF SETTING UP FOR FIRST TIME
        // const tx_set_FantomSatelite_1 =  await AxelarMoonbeamSatelite_instance.set_FantomSatelite(axelarFantomSatelite_address);
        // tx_set_FantomSatelite_1.wait().then( async reslveMsg => {
        //     console.log(`tx_set_FantomSatelite_1 is mined resolveMsg : `,reslveMsg);
        // });

        // const tx2 =  await AxelarMoonbeamSatelite_instance.set_OrdersManager(ordersManager_address,usersRegistry_address);
        // tx2.wait().then( async reslveMsg => {
        //     console.log(`tx2 AxelarMoonbeamSatelite_instance.set_OrdersManager is mined resolveMsg : `,reslveMsg);
        // });

        // const admin_of_AxelarMoonbeamSatelite_instance =  await AxelarMoonbeamSatelite_instance.admin();
        console.log(`********************* AxelarMoonbeamSatelite_instance Setting Up End ***********************************`);
        console.log("");
        console.log("");


        console.log(`********************* ExecutionOrdersEngineFromFantom_instance Setting Up Start ***********************************`);
        // // UNCOMMENT AND RUN IF SETTING UP FOR FIRST TIME
        // const tx_set_FantomSatelite_2 =  await ExecutionOrdersEngineFromFantom_instance.set_FantomSatelite(axelarFantomSatelite_address);
        // tx_set_FantomSatelite_2.wait().then( async reslveMsg => {
        //     console.log(`tx_set_FantomSatelite_2 is mined resolveMsg : `,reslveMsg);
        // });

        // const tx_set_StellaSwap3 =  await ExecutionOrdersEngineFromFantom_instance.set_StellaSwap(stellaSwap_address);
        // tx_set_StellaSwap3.wait().then( async reslveMsg => {
        // 	 console.log(`tx ExecutionOrdersEngineFromFantom_instance.set_StellaSwap is mined resolveMsg : `,reslveMsg);
        // });
        console.log(`********************* ExecutionOrdersEngineFromFantom_instance Setting Up End ***********************************`);
        console.log("");
        console.log("");

    console.log(`********************* Setting Up SC Start ***********************************`);

    
    console.log(`********************* BOOKS START ***********************************`);
    console.log(`********************* OrdersManager_instance OPEN WORKING ORDERS Start ***********************************`);
    const get_OrderBooks = async () => {
        let limitOrdersArray =  await OrdersManager_instance.get_limitOrdersArray();
        for (let i=0; i<limitOrdersArray.length; i++)
        {
            let ord =  await OrdersManager_instance.Orders(limitOrdersArray[i]);
            console.log(` =-----> limitOrdersArray[${i}]  : ${limitOrdersArray[i]} nonce: ${ord.nonce} owner: ${ord.owner} tokenIn: ${`${ord.tokenIn}`.substring(0,5)}...${`${ord.tokenIn}`.substring(36)} tokenOut: ${`${ord.tokenOut}`.substring(0,5)}...${`${ord.tokenOut}`.substring(36)} limit_price: ${ord.limit_price} stop_price: ${ord.stop_price} size: ${ord.size} block_submitted: ${ord.block_submitted} numOfsplits: ${ord.numOfsplits} order_type: ${ord.order_type} positionAr: ${ord.positionAr} dcaBlockInterval: ${ord.dcaBlockInterval}`);
        }
        let stopOrdersArray =  await OrdersManager_instance.get_stopOrdersArray();
        for (let i=0; i<stopOrdersArray.length; i++)
        {
            let ord =  await OrdersManager_instance.Orders(stopOrdersArray[i]);
            console.log(` =-----> stopOrdersArray[${i}]   : ${stopOrdersArray[i]} nonce: ${ord.nonce} owner: ${ord.owner} tokenIn:${`${ord.tokenIn}`.substring(0,5)}...${`${ord.tokenIn}`.substring(36)} tokenOut:${`${ord.tokenOut}`.substring(0,5)}...${`${ord.tokenOut}`.substring(36)} limit_price: ${ord.limit_price} stop_price: ${ord.stop_price} size: ${ord.size} block_submitted: ${ord.block_submitted} numOfsplits: ${ord.numOfsplits} order_type: ${ord.order_type} positionAr: ${ord.positionAr} dcaBlockInterval: ${ord.dcaBlockInterval}`);
        }
        let bracketOrdersArray =  await OrdersManager_instance.get_bracketOrdersArray();
        for (let i=0; i<bracketOrdersArray.length; i++)
        {
            let ord =  await OrdersManager_instance.Orders(bracketOrdersArray[i]);
            console.log(` =-----> bracketOrdersArray[${i}]: ${bracketOrdersArray[i]} nonce: ${ord.nonce} owner: ${ord.owner} tokenIn: ${`${ord.tokenIn}`.substring(0,5)}...${`${ord.tokenIn}`.substring(36)} tokenOut: ${`${ord.tokenOut}`.substring(0,5)}...${`${ord.tokenOut}`.substring(36)} limit_price: ${ord.limit_price} stop_price: ${ord.stop_price} size: ${ord.size} block_submitted: ${ord.block_submitted} numOfsplits: ${ord.numOfsplits} order_type: ${ord.order_type} positionAr: ${ord.positionAr} dcaBlockInterval: ${ord.dcaBlockInterval}`);
        }
        let dcaOrdersArray =  await OrdersManager_instance.get_dcaOrdersArray();
        for (let i=0; i<dcaOrdersArray.length; i++)
        {
            let ord =  await OrdersManager_instance.Orders(dcaOrdersArray[i]);
            console.log(` =-----> dcaOrdersArray[${i}]    : ${dcaOrdersArray[i]} nonce: ${ord.nonce} owner: ${ord.owner} tokenIn: ${`${ord.tokenIn}`.substring(0,5)}...${`${ord.tokenIn}`.substring(36)} tokenOut: ${`${ord.tokenOut}`.substring(0,5)}...${`${ord.tokenOut}`.substring(36)} limit_price: ${ord.limit_price} stop_price: ${ord.stop_price} size: ${ord.size} block_submitted: ${ord.block_submitted} numOfsplits: ${ord.numOfsplits} order_type: ${ord.order_type} positionAr: ${ord.positionAr} dcaBlockInterval: ${ord.dcaBlockInterval}`);
        }
    }
    // await get_OrderBooks();
    console.log(`********************* OrdersManager_instance OPEN WORKING ORDERS End ***********************************`);
    console.log("");
    console.log("");


    console.log(`********************* ExecutionOrdersEngineMoonbeam Start ***********************************`);
    const get_ExecutionsPendingOrderBook = async () => {
        let pendingOrders_MOONBEAM =  await ExecutionOrdersEngineMoonbeam_instance.get_pendingOrders_MOONBEAM();
        for (let i=0; i<pendingOrders_MOONBEAM.length; i++)
        {
            let ord =  await ExecutionOrdersEngineMoonbeam_instance.Orders(pendingOrders_MOONBEAM[i]);
            console.log(` =-----> pendingOrders_MOONBEAM[${i}]: ${pendingOrders_MOONBEAM[i]}  engine_nonce: ${ord.engine_nonce} origin_nonce: ${ord.origin_nonce} owner: ${ord.owner} tokenIn:${`${ord.tokenIn}`.substring(0,5)}...${`${ord.tokenIn}`.substring(36)} tokenOut:${`${ord.tokenOut}`.substring(0,5)}...${`${ord.tokenOut}`.substring(36)} limit_price: ${ord.limit_price} stop_price: ${ord.stop_price} size: ${ord.size} block_submitted: ${ord.block_submitted} order_type: ${ord.order_type} positionAr: ${ord.positionAr}`);
        }
    }
    // await get_ExecutionsPendingOrderBook();
    console.log(`********************* ExecutionOrdersEngineMoonbeam End ***********************************`);
    console.log("");
    console.log("");


    console.log(`********************* ExecutionOrdersEngineFromFantom Start ***********************************`);
    const get_ExecutionOrdersEngineFromFantom_Books = async () => {

        const pendingOrders_FromFANTOM_NON_USDC =  await ExecutionOrdersEngineFromFantom_instance.get_pendingOrders_FromFANTOM_NON_USDC();
        console.log(` =-----> pendingOrders_FromFANTOM_NON_USDC: `,pendingOrders_FromFANTOM_NON_USDC);

        const pendingOrders_FromFANTOM_USDC =  await ExecutionOrdersEngineFromFantom_instance.get_pendingOrders_FromFANTOM_USDC();
        console.log(` =-----> pendingOrders_FromFANTOM_USDC: `,pendingOrders_FromFANTOM_USDC);

        const pendingFinancedOrders_FromFANTOM_USDC =  await ExecutionOrdersEngineFromFantom_instance.get_pendingFinancedOrders_FromFANTOM_USDC();
        console.log(` =-----> pendingFinancedOrders_FromFANTOM_USDC: `,pendingFinancedOrders_FromFANTOM_USDC);

        const unfinancedOrderNoncesToDelete =  await ExecutionOrdersEngineFromFantom_instance.get_unfinancedOrderNoncesToDelete();
        console.log(` =-----> unfinancedOrderNoncesToDelete: `,unfinancedOrderNoncesToDelete);
    }
    // await get_ExecutionOrdersEngineFromFantom_Books();
    console.log(`********************* ExecutionOrdersEngineFromFantom End ***********************************`);
    console.log("");
    console.log("");

    console.log(`********************* BOOKS END ***********************************`);





    console.log(`********************* Prices Start ***********************************`);
    const get_Prices = async () => {
        const dot_USDC   = await OrdersManager_instance.priceUSDC(xcDOT_address);
        const wglmr_USDC = await OrdersManager_instance.priceUSDC(WGLMR_address);
        const astr_USDC  = await OrdersManager_instance.priceUSDC(xcASTR_address);
        console.log(` PRICES |>     dot_USDC: ${dot_USDC}   wglmr_USDC: ${wglmr_USDC}   astr_USDC: ${astr_USDC}`);
    }
    // await get_Prices()
    console.log(`********************* Prices End ***********************************`);
    console.log("");
    console.log("");


    console.log(`********************* OrdersManager_instance GET DETAILS OF AN ORDER  Start ***********************************`);
    // let some_order =  await OrdersManager_instance.Orders(4);
    // console.log(` =---> some_order: `,some_order);
    console.log(`********************* OrdersManager_instance GET DETAILS OF AN ORDER  End ***********************************`);
    console.log("");
    console.log("");

    console.log(`********************* OrdersManager_instance BUILD FICTIONAL ORDER BOOK ***********************************`);
    // let tx_submit_limit_order,tx_submit_stop_order,tx_submit_bracket_order,tx_submit_DCA_order;
    // // function submit_Order(address _owner, address tokenIn, address tokenOut, uint limit_price, uint stop_price, uint size, uint num_Ofsplits, uint order_type, uint _dcaBlockInterval )

    // console.log(`***** Submiting Limit Order ****`);
    // tx_submit_limit_order =  await OrdersManager_instance.submit_Order( adminAddress, USDC_address, xcDOT_address, 20, 0, 23, 0, 1, 0 );
    // tx_submit_limit_order.wait().then( async reslveMsg => {
    //     console.log(`tx_submit_limit_order is mined resolveMsg : `,reslveMsg);

    //     limitOrdersArray =  await OrdersManager_instance.get_limitOrdersArray();
    //     console.log(`limitOrdersArray: `,limitOrdersArray);
    // });
    // tx_submit_limit_order =  await OrdersManager_instance.submit_Order( adminAddress, USDC_address, xcDOT_address, 22, 0, 23, 0, 1, 0 );
    // tx_submit_limit_order.wait().then( async reslveMsg => {
    //     console.log(`tx_submit_limit_order is mined resolveMsg : `,reslveMsg);

    //     limitOrdersArray =  await OrdersManager_instance.get_limitOrdersArray();
    //     console.log(`limitOrdersArray: `,limitOrdersArray);
    // });
    // tx_submit_limit_order =  await OrdersManager_instance.submit_Order( adminAddress, USDC_address, xcDOT_address, 24, 0, 23, 0, 1, 0 );
    // tx_submit_limit_order.wait().then( async reslveMsg => {
    //     console.log(`tx_submit_limit_order is mined resolveMsg : `,reslveMsg);

    //     limitOrdersArray =  await OrdersManager_instance.get_limitOrdersArray();
    //     console.log(`limitOrdersArray: `,limitOrdersArray);
    // });
    // tx_submit_limit_order =  await OrdersManager_instance.submit_Order( adminAddress, USDC_address, xcDOT_address, 26, 0, 23, 0, 1, 0 );
    // tx_submit_limit_order.wait().then( async reslveMsg => {
    //     console.log(`tx_submit_limit_order is mined resolveMsg : `,reslveMsg);

    //     limitOrdersArray =  await OrdersManager_instance.get_limitOrdersArray();
    //     console.log(`limitOrdersArray: `,limitOrdersArray);
    // });


    // console.log(`***** Submiting Stop Order ****`);
    // tx_submit_stop_order =  await OrdersManager_instance.submit_Order( adminAddress, xcDOT_address, USDC_address, 0, 17, 15, 0, 2, 0 );
    // tx_submit_stop_order.wait().then( async reslveMsg => {
    //     console.log(`tx_submit_stop_order is mined resolveMsg : `,reslveMsg);

    //     stopOrdersArray =  await OrdersManager_instance.get_stopOrdersArray();
    //     console.log(`stopOrdersArray: `,stopOrdersArray);
    // });
    // tx_submit_stop_order =  await OrdersManager_instance.submit_Order( adminAddress, xcDOT_address, USDC_address, 0, 16, 15, 0, 2, 0 );
    // tx_submit_stop_order.wait().then( async reslveMsg => {
    //     console.log(`tx_submit_stop_order is mined resolveMsg : `,reslveMsg);

    //     stopOrdersArray =  await OrdersManager_instance.get_stopOrdersArray();
    //     console.log(`stopOrdersArray: `,stopOrdersArray);
    // });
    // tx_submit_stop_order =  await OrdersManager_instance.submit_Order( adminAddress, xcDOT_address, USDC_address, 0, 15, 15, 0, 2, 0 );
    // tx_submit_stop_order.wait().then( async reslveMsg => {
    //     console.log(`tx_submit_stop_order is mined resolveMsg : `,reslveMsg);

    //     stopOrdersArray =  await OrdersManager_instance.get_stopOrdersArray();
    //     console.log(`stopOrdersArray: `,stopOrdersArray);
    // });
    // tx_submit_stop_order =  await OrdersManager_instance.submit_Order( adminAddress, xcDOT_address, USDC_address, 0, 14, 15, 0, 2, 0 );
    // tx_submit_stop_order.wait().then( async reslveMsg => {
    //     console.log(`tx_submit_stop_order is mined resolveMsg : `,reslveMsg);

    //     stopOrdersArray =  await OrdersManager_instance.get_stopOrdersArray();
    //     console.log(`stopOrdersArray: `,stopOrdersArray);
    // });

    // console.log(`***** Submiting Bracket Order ****`);
    // tx_submit_bracket_order =  await OrdersManager_instance.submit_Order( adminAddress, xcDOT_address, USDC_address, 25, 15, 55, 0, 3, 0 );
    // tx_submit_bracket_order.wait().then( async reslveMsg => {
    //     console.log(`tx_submit_bracket_order is mined resolveMsg : `,reslveMsg);

    //     bracketOrdersArray =  await OrdersManager_instance.get_bracketOrdersArray();
    //     console.log(`bracketOrdersArray: `,bracketOrdersArray);
    // });
    // tx_submit_bracket_order =  await OrdersManager_instance.submit_Order( adminAddress, xcDOT_address, USDC_address, 30, 10, 55, 0, 3, 0 );
    // tx_submit_bracket_order.wait().then( async reslveMsg => {
    //     console.log(`tx_submit_bracket_order is mined resolveMsg : `,reslveMsg);

    //     bracketOrdersArray =  await OrdersManager_instance.get_bracketOrdersArray();
    //     console.log(`bracketOrdersArray: `,bracketOrdersArray);
    // });
    // tx_submit_bracket_order =  await OrdersManager_instance.submit_Order( adminAddress, xcDOT_address, USDC_address, 40, 5, 55, 0, 3, 0 );
    // tx_submit_bracket_order.wait().then( async reslveMsg => {
    //     console.log(`tx_submit_bracket_order is mined resolveMsg : `,reslveMsg);

    //     bracketOrdersArray =  await OrdersManager_instance.get_bracketOrdersArray();
    //     console.log(`bracketOrdersArray: `,bracketOrdersArray);
    // });

    // console.log(`***** Submiting DCA Order ****`);
    // tx_submit_DCA_order =  await OrdersManager_instance.submit_Order( adminAddress, USDC_address, xcDOT_address, 0, 0, 90, 2, 4, 5 );  //buy 30 lots in 3 splits so 10 lots per split every 5 blocks from now
    // tx_submit_DCA_order.wait().then( async reslveMsg => {
    //     console.log(`tx_submit_DCA_order is mined resolveMsg : `,reslveMsg);

    //     dcaOrdersArray =  await OrdersManager_instance.get_dcaOrdersArray();
    //     console.log(`dcaOrdersArray: `,dcaOrdersArray);
    // });
    // tx_submit_DCA_order =  await OrdersManager_instance.submit_Order( adminAddress, USDC_address, xcDOT_address, 0, 0, 90, 3, 4, 5 );  //buy 30 lots in 3 splits so 10 lots per split every 5 blocks from now
    // tx_submit_DCA_order.wait().then( async reslveMsg => {
    //     console.log(`tx_submit_DCA_order is mined resolveMsg : `,reslveMsg);

    //     dcaOrdersArray =  await OrdersManager_instance.get_dcaOrdersArray();
    //     console.log(`dcaOrdersArray: `,dcaOrdersArray);
    // });
    // tx_submit_DCA_order =  await OrdersManager_instance.submit_Order( adminAddress, USDC_address, xcDOT_address, 0, 0, 90, 9, 4, 5 );  //buy 30 lots in 3 splits so 10 lots per split every 5 blocks from now
    // tx_submit_DCA_order.wait().then( async reslveMsg => {
    //     console.log(`tx_submit_DCA_order is mined resolveMsg : `,reslveMsg);

    //     dcaOrdersArray =  await OrdersManager_instance.get_dcaOrdersArray();
    //     console.log(`dcaOrdersArray: `,dcaOrdersArray);
    // });

    console.log("");
    console.log("");

    console.log(`********************* OrdersManager_instance DELETE ORDER Start ***********************************`);
    // let tx_delete_order; 
    // let orderNonce = 5 ;
	// const gasEstimate = await OrdersManager_instance.estimateGas.delete_Order( orderNonce ); //ethers.BigNumber.from( "300000" ); 
    // console.log(`gasEstimate: ${gasEstimate}`);
    // tx_delete_order =  await OrdersManager_instance.delete_Order( orderNonce, { gasLimit: gasEstimate } );
    // tx_delete_order.wait().then( async reslveMsg => {
    //      console.log(`tx_delete_order is mined resolveMsg : `,reslveMsg);
    //      await get_OrderBooks();
    // });
    console.log(`********************* OrdersManager_instance DELETE ORDER End ***********************************`);
    console.log("");
    console.log("");

    console.log(`********************* ExecutionOrdersEngineMoonbeam_instance DELETE ORDER Start ***********************************`);
    // let tx_delete_ExecutionEngine_order =  await ExecutionOrdersEngineMoonbeam_instance.delete_Order( 9 );
    // tx_delete_ExecutionEngine_order.wait().then( async reslveMsg => {
    //      console.log(`tx_delete_ExecutionEngine_order is mined resolveMsg : `,reslveMsg);
    // });
    console.log(`********************* ExecutionOrdersEngineMoonbeam_instance DELETE ORDER End ***********************************`);
    console.log("");
    console.log("");

    console.log(`********************* OrdersManager_instance SET STELLASWAP Prices Start ***********************************`);
    // let tx_set_StellaSwapPrice =  await OrdersManager_instance.get_StellaSwapPrice();
    // tx_set_StellaSwapPrice.wait().then( async reslveMsg => {
    //     console.log(`tx_set_StellaSwapPrice is mined resolveMsg : `,reslveMsg);
    // });
    console.log(`********************* OrdersManager_instanceSET STELLASWAP Prices End ***********************************`);
    console.log("");
    console.log("");


    // console.log(`********************* OrdersManager_instance Set Artifical Prices Start ***********************************`);
    // // let tx_set_artifical_StellaSwapPrice =  await OrdersManager_instance.set_artifical_StellaSwapPrice( 20, 11, 10 );
    // // tx_set_artifical_StellaSwapPrice.wait().then( async reslveMsg => {
    // //     console.log(`tx_set_artifical_StellaSwapPrice is mined resolveMsg : `,reslveMsg);
    // // });
    // console.log(`********************* OrdersManager_instance Set Artifical Prices End ***********************************`);
    // console.log("");
    // console.log("");


    const checkLimitOrders = async () => {
        console.log(`*********************  checkLimitOrders Start ***********************************`);
        let tx_checkLimitOrders; 
        tx_checkLimitOrders =  await OrdersManager_instance.checkLimitOrders();
        tx_checkLimitOrders.wait().then( async reslveMsg => {
            console.log(`tx_checkLimitOrders is mined resolveMsg : `,reslveMsg);
            console.log(`*********************  checkLimitOrders End ***********************************`);
        });
    }
    // await checkLimitOrders();
    console.log("");
    console.log("");

    const checkStopOrders = async () => {
        console.log(`*********************  checkStopOrders Start ***********************************`);
        let tx_checkStopOrders; 
        tx_checkStopOrders =  await OrdersManager_instance.checkStopOrders();
        tx_checkStopOrders.wait().then( async reslveMsg => {
            console.log(`tx_checkStopOrders is mined resolveMsg : `,reslveMsg);
            console.log(`*********************  checkStopOrders End ***********************************`);
        });
    }
    // await checkStopOrders();
    console.log("");
    console.log("");

    const checkBracketOrders = async () => {
        console.log(`*********************  checkBracketOrders Start ***********************************`);
        let tx_checkBracketOrders; 
        tx_checkBracketOrders =  await OrdersManager_instance.checkBracketOrders();
        tx_checkBracketOrders.wait().then( async reslveMsg => {
            console.log(`tx_checkBracketOrders is mined resolveMsg : `,reslveMsg);
            console.log(`*********************  checkBracketOrders End ***********************************`);
        });
    }
    // await checkBracketOrders();
    console.log("");
    console.log("");

    const checkDCAOrders = async () => {
        console.log(`*********************  checkDCAOrders Start ***********************************`);
        let tx_checkDCAOrders; 
        tx_checkDCAOrders =  await OrdersManager_instance.checkDCAOrders();
        tx_checkDCAOrders.wait().then( async reslveMsg => {
            console.log(`tx_checkDCAOrders is mined resolveMsg : `,reslveMsg);
            console.log(`*********************  checkDCAOrders End ***********************************`);
        });
    }
    // await checkDCAOrders();
    console.log("");
    console.log("");





console.log(`******************** ORDERS SUBMITTED FROM FANTOM TO MOONBEAM MANAGEMENT START ************************************`);

    const requestPendingOrdersFinancing = async () => {
        console.log(`*********************  requestPendingOrdersFinancing ExecutionOrdersEngineFromFantom_instance Start ***********************************`);

        const pendingOrders_FromFANTOM_USDC =  await ExecutionOrdersEngineFromFantom_instance.get_pendingOrders_FromFANTOM_USDC();
        console.log(` =-----> pendingOrders_FromFANTOM_USDC: `,pendingOrders_FromFANTOM_USDC);

        if (pendingOrders_FromFANTOM_USDC.length > 0)
        {
            console.log(` ===> WILL NOW RUN requestPendingOrdersFinancing ExecutionOrdersEngineFromFantom_instance BECAUSE pendingOrders_FromFANTOM_USDC.length: ${pendingOrders_FromFANTOM_USDC.length} > 0 <===`);

            const tx_requestPendingOrdersFinancing =  await ExecutionOrdersEngineFromFantom_instance.requestPendingOrdersFinancing( {value: ethers.utils.parseEther("1.5")} );
            tx_requestPendingOrdersFinancing.wait().then( async reslveMsg => {
                console.log(`tx_requestPendingOrdersFinancing is mined resolveMsg : `,reslveMsg);
                console.log(`********************* requestPendingOrdersFinancing ExecutionOrdersEngineFromFantom_instance End ***********************************`);
            });
        }

    }
    // await requestPendingOrdersFinancing();
    console.log("");
    console.log("");


    const delete_Unfinanced_Orders = async () => {
        console.log(`*********************  delete_Unfinanced_Orders ExecutionOrdersEngineFromFantom_instance Start ***********************************`);
        
        // ONLY TO SAVE ON FEES
        const unfinancedOrderNoncesToDelete =  await ExecutionOrdersEngineFromFantom_instance.get_unfinancedOrderNoncesToDelete();
        console.log(` =-----> unfinancedOrderNoncesToDelete: `,unfinancedOrderNoncesToDelete);

        if (unfinancedOrderNoncesToDelete.length > 0)
        {
            console.log(` ===> WILL NOW RUN delete_Unfinanced_Orders ExecutionOrdersEngineFromFantom_instance BECAUSE unfinancedOrderNoncesToDelete.length: ${unfinancedOrderNoncesToDelete.length} > 0 <===`);

            const tx_delete_Unfinanced_Orders =  await ExecutionOrdersEngineFromFantom_instance.delete_Unfinanced_Orders();
            tx_delete_Unfinanced_Orders.wait().then( async reslveMsg => {
                console.log(`tx_delete_Unfinanced_Orders is mined resolveMsg : `,reslveMsg);
                console.log(`********************* delete_Unfinanced_Orders ExecutionOrdersEngineFromFantom_instance End ***********************************`);
            });
        }

    }
    // await delete_Unfinanced_Orders();
    console.log("");
    console.log("");


    // THIS TELLS YOU IF THERE ARE ANY ORDERS READY TO BE EXECUTED FROM USDC TO TOKEN => READ NONCE THEN CALL FUNCTION BELOW TO EXECUTE ORDER
    // const pendingFinancedOrders_FromFANTOM_USDC =  await ExecutionOrdersEngineFromFantom_instance.get_pendingFinancedOrders_FromFANTOM_USDC();
    // console.log(` =-----> pendingFinancedOrders_FromFANTOM_USDC: `,pendingFinancedOrders_FromFANTOM_USDC);
    const executeOrder_Moonbeam_BuyWithUSDC = async (orderNonce) => {
        console.log(`*********************  executeOrder_Moonbeam_BuyWithUSDC ExecutionOrdersEngineFromFantom_instance Start ***********************************`);

        const tx_executeOrder_Moonbeam_BuyWithUSDC =  await ExecutionOrdersEngineFromFantom_instance.executeOrder_Moonbeam_BuyWithUSDC(orderNonce);
        tx_executeOrder_Moonbeam_BuyWithUSDC.wait().then( async reslveMsg => {
            console.log(`tx_executeOrder_Moonbeam_BuyWithUSDC is mined resolveMsg : `,reslveMsg);
            console.log(`********************* executeOrder_Moonbeam_BuyWithUSDC ExecutionOrdersEngineFromFantom_instance End ***********************************`);
        });

    }
    // await executeOrder_Moonbeam_BuyWithUSDC();
    console.log("");
    console.log("");


    // THIS TELLS YOU IF THERE ARE ANY ORDERS READY TO BE EXECUTED FROM TOKEN TO USDC TO => READ NONCE THEN CALL FUNCTION BELOW TO EXECUTE ORDER
    // const pendingOrders_FromFANTOM_NON_USDC =  await ExecutionOrdersEngineFromFantom_instance.get_pendingOrders_FromFANTOM_NON_USDC();
    // console.log(` =-----> pendingOrders_FromFANTOM_NON_USDC: `,pendingOrders_FromFANTOM_NON_USDC);

    const executeOrder_Moonbeam_NONUSDC = async (orderNonce) => {
        console.log(`*********************  executeOrder_Moonbeam_NONUSDC ExecutionOrdersEngineFromFantom_instance Start ***********************************`);

        const tx_executeOrder_Moonbeam_NONUSDC =  await ExecutionOrdersEngineFromFantom_instance.executeOrder_Moonbeam_NONUSDC(orderNonce, {value: ethers.utils.parseEther("1.5")} );
        tx_executeOrder_Moonbeam_NONUSDC.wait().then( async reslveMsg => {
            console.log(`tx_executeOrder_Moonbeam_NONUSDC is mined resolveMsg : `,reslveMsg);
            console.log(`********************* executeOrder_Moonbeam_NONUSDC ExecutionOrdersEngineFromFantom_instance End ***********************************`);
        });

    }
    // await executeOrder_Moonbeam_NONUSDC();
    console.log("");
    console.log("");

console.log(`******************** ORDERS SUBMITTED FROM FANTOM TO MOONBEAM MANAGEMENT END ************************************`);




console.log(`********************************************************`);

}
  
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
