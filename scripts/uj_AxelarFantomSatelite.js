// npx hardhat run scripts/uj_AxelarFantomSatelite.js
// or npx hardhat run --network <your-network> scripts/uj_AxelarFantomSatelite.js

// npx hardhat run --network Fantom scripts/uj_AxelarFantomSatelite.js
 

//***** Smart Contract Address *****/
//FANTOM
const axelarFantomSatelite_address = "0x4Ff100bc3b2f40F9F2AF03D095b1Bc5875538321"; //"0x27d7222AD292d017C6eE1f0B8043Da7F4424F6a0";
const axlUSDC_address = "0x1B6382DBDEa11d97f24495C9A90b7c88469134a4";    //6 decimals

//MOONBEAM
const axelarMoonbeamSatelite_address = "0xb85E1D77d6430bBDAF91845181440407c3c2bf6b";
const executionOrdersEngineFromFantom_address = "0xc259A95E717ccf5aEDA5971CE967E528Fa624Bc4";


const xcASTR_address  = "0xFfFFFfffA893AD19e540E172C10d78D4d479B5Cf";
const WGLMR_address   = "0xAcc15dC74880C9944775448304B263D191c6077F";    //18 decimals
const xcDOT_address   = "0xFfFFfFff1FcaCBd218EDc0EbA20Fc2308C778080";    //10 decimals
const USDC_address    = "0x931715FEE2d06333043d11F658C8CE934aC61D0c";    //6 decimals
// const axlUSDC_address = "0xCa01a1D0993565291051daFF390892518ACfAD3A";    //6 decimals

//*****/

//***** Smart Contract ABIs *****/
const AxelarFantomSatelite_JSON = require("../artifacts/contracts/Moonbeam/Fantom/AxelarFantomSatelite.sol/AxelarFantomSatelite.json");

const IERC20_JSON = require("../artifacts/contracts/IERC20.sol/IERC20.json");

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
    const AxelarFantomSatelite_instance  = new Contract(axelarFantomSatelite_address, AxelarFantomSatelite_JSON.abi, admin);
    console.log(`AxelarFantomSatelite_instance.address: ${AxelarFantomSatelite_instance.address}`);

    const axlUSDC_instance  = new Contract(axlUSDC_address, IERC20_JSON.abi, admin);
    console.log(`axlUSDC_instance.address: ${axlUSDC_instance.address}`);
    console.log("");
    console.log("");


    console.log(`********************* AxelarFantomSatelite_instance Setting Up Start ***********************************`);
    // // UNCOMMENT AND RUN IF SETTING UP FOR FIRST TIME
    const tx_set_MoonbeamSatelite =  await AxelarFantomSatelite_instance.set_MoonbeamSatelite(axelarMoonbeamSatelite_address,executionOrdersEngineFromFantom_address);
	tx_set_MoonbeamSatelite.wait().then( async reslveMsg => {
		 console.log(`tx_set_MoonbeamSatelite is mined resolveMsg : `,reslveMsg);
	});
    console.log(`********************* AxelarFantomSatelite_instance Setting Up End ***********************************`);
    console.log("");
    console.log("");

  


    console.log(`********************* AxelarFantomSatelite_instance Get Arrays Start ***********************************`);
    
    const get_OrderBooks = async () => {
        
        let finance_Order_Nonces_ToSend =  await AxelarFantomSatelite_instance.get_finance_Order_Nonces_ToSend();
        console.log(` =-----> finance_Order_Nonces_ToSend: `,finance_Order_Nonces_ToSend);

        let finance_Order_Nonces_ToDelete =  await AxelarFantomSatelite_instance.get_finance_Order_Nonces_ToDelete();
        console.log(` =-----> finance_Order_Nonces_ToDelete: `,finance_Order_Nonces_ToDelete);

        let finance_Order_Sizes_ToSend =  await AxelarFantomSatelite_instance.get_finance_Order_Sizes_ToSend();
        console.log(` =-----> finance_Order_Sizes_ToSend: `,finance_Order_Sizes_ToSend);

        let finance_Order_Owners_ToSend =  await AxelarFantomSatelite_instance.get_finance_Order_Owners_ToSend();
        console.log(` =-----> finance_Order_Owners_ToSend: `,finance_Order_Owners_ToSend);

        let finance_orderNonces =  await AxelarFantomSatelite_instance.get_finance_orderNonces();
        console.log(` =-----> finance_orderNonces: `,finance_orderNonces);

        let finance_OrderOwnerAddresses =  await AxelarFantomSatelite_instance.get_finance_OrderOwnerAddresses();
        console.log(` =-----> finance_OrderOwnerAddresses: `,finance_OrderOwnerAddresses);

        let finance_OrderSizes =  await AxelarFantomSatelite_instance.get_finance_OrderSizes();
        console.log(` =-----> finance_OrderSizes: `,finance_OrderSizes);
        
        let received_order_Nonces =  await AxelarFantomSatelite_instance.get_received_order_Nonces();
        console.log(` =-----> received_order_Nonces: `,received_order_Nonces);

        let received_order_OwnerAddresses =  await AxelarFantomSatelite_instance.get_received_order_OwnerAddresses();
        console.log(` =-----> received_order_OwnerAddresses: `,received_order_OwnerAddresses);

        let received_order_Sizes =  await AxelarFantomSatelite_instance.get_received_order_Sizes();
        console.log(` =-----> received_order_Sizes: `,received_order_Sizes);
    }
    // await get_OrderBooks();
    console.log(`********************* AxelarFantomSatelite_instance Get Arrays End ***********************************`);
    console.log("");
    console.log("");



    console.log(`********************* AxelarFantomSatelite_instance BUILD FICTIONAL ORDER BOOK ***********************************`);
    
    // ***
    let tx_approve_axlUSDC, tx_submit_order;
    // USDC => DOT
    console.log(`***** Submiting Limit Order ****`);

    //APPROVE this SC for axlUSDC
    let axlUSDC_allowance;
    axlUSDC_allowance =  await axlUSDC_instance.allowance( adminAddress, axelarFantomSatelite_address);
    console.log(`***** axlUSDC ALLOWANCE of user: ${adminAddress} to axelarFantomSatelite_address: ${axelarFantomSatelite_address} is: ${axlUSDC_allowance}`);
    

    const  limitOrder_size_1 = 101234;
    // tx_approve_axlUSDC =  await axlUSDC_instance.approve( axelarFantomSatelite_address, axlUSDC_allowance.add(limitOrder_size_1));
    // tx_approve_axlUSDC.wait().then( async reslveMsg => {
    //     console.log(`tx_approve_axlUSDC is mined resolveMsg : `,reslveMsg);

    //     axlUSDC_allowance =  await axlUSDC_instance.allowance( adminAddress, axelarFantomSatelite_address);
    //     console.log(`***** AFTER APPROVAL axlUSDC ALLOWANCE of user: ${adminAddress} to axelarFantomSatelite_address: ${axelarFantomSatelite_address} is: ${axlUSDC_allowance}`);
    // });

    // tx_submit_order =  await AxelarFantomSatelite_instance.submitOrderTo_Moonbeam( USDC_address, xcDOT_address, 4321012, 0, limitOrder_size_1, 0, 1, 0, {value: ethers.utils.parseEther("1.0")} );
    // tx_submit_order.wait().then( async reslveMsg => {
    //     console.log(`tx_submit_order is mined resolveMsg : `,reslveMsg);
    // });


    const  limitOrder_size_2 = 102222;
    // tx_approve_axlUSDC =  await axlUSDC_instance.approve( axelarFantomSatelite_address,  axlUSDC_allowance.add(limitOrder_size_2));
    // tx_approve_axlUSDC.wait().then( async reslveMsg => {
    //     console.log(`tx_approve_axlUSDC is mined resolveMsg : `,reslveMsg);

    //     axlUSDC_allowance =  await axlUSDC_instance.allowance( adminAddress, axelarFantomSatelite_address);
    //     console.log(`***** AFTER APPROVAL axlUSDC ALLOWANCE of user: ${adminAddress} to axelarFantomSatelite_address: ${axelarFantomSatelite_address} is: ${axlUSDC_allowance}`);
    // });

    // tx_submit_order =  await AxelarFantomSatelite_instance.submitOrderTo_Moonbeam( USDC_address, xcDOT_address, 5510257, 0, limitOrder_size_2, 0, 1, 0, {value: ethers.utils.parseEther("1.0")} );
    // tx_submit_order.wait().then( async reslveMsg => {
    //     console.log(`tx_submit_order is mined resolveMsg : `,reslveMsg);
    // });


    // ***
    // console.log(`***** Submiting Stop Order ****`);
    // // DOT => USDC
    // tx_submit_order =  await AxelarFantomSatelite_instance.submitOrderTo_Moonbeam( xcDOT_address, USDC_address, 0, 5910257, 100372954, 0, 2, 0);
    // tx_submit_order.wait().then( async reslveMsg => {
    //     console.log(`tx_submit_order is mined resolveMsg : `,reslveMsg);
    // });
    console.log("");
    console.log("");



    console.log(`********************* AxelarFantomSatelite_instance delete order Start ***********************************`);
    const orderNonce = 2;
    // let tx_deleteOrder =  await AxelarFantomSatelite_instance.cancelOrderTo_Moonbeam(orderNonce, {value: ethers.utils.parseEther("1.0")} );
    // tx_deleteOrder.wait().then( async reslveMsg => {
    //      console.log(`tx_deleteOrder is mined resolveMsg : `,reslveMsg);
    // });
    console.log(`********************* AxelarFantomSatelite_instance delete order End ***********************************`);
    console.log("");
    console.log("");






    const requestOrderAXLUSDCfinancing = async () => {
        console.log(`*********************  requestOrderAXLUSDCfinancing Start ***********************************`);
        const tx_requestOrderAXLUSDCfinancing =  await AxelarFantomSatelite_instance.requestOrderAXLUSDCfinancing();
        tx_requestOrderAXLUSDCfinancing.wait().then( async reslveMsg => {
            console.log(`tx_requestOrderAXLUSDCfinancing is mined resolveMsg : `,reslveMsg);
            console.log(`*********************  requestOrderAXLUSDCfinancing End ***********************************`);
        });
    }
    // await requestOrderAXLUSDCfinancing();
    console.log("");
    console.log("");




    const financeOrdersTo_Execute = async () => {
        console.log(`*********************  financeOrdersTo_Execute Start ***********************************`);

        const finance_Order_Nonces_ToSend =  await AxelarFantomSatelite_instance.get_finance_Order_Nonces_ToSend();
        console.log(` =-----> finance_Order_Nonces_ToSend: `,finance_Order_Nonces_ToSend);

        if (finance_Order_Nonces_ToSend.length > 0)
        {
            console.log(` ===> WILL NOW RUN financeOrdersTo_Execute BECAUSE finance_Order_Nonces_ToSend.length: ${finance_Order_Nonces_ToSend.length} > 0 <===`);

            const tx_financeOrdersTo_Execute =  await AxelarFantomSatelite_instance.financeOrdersTo_Execute( {value: ethers.utils.parseEther("1.0")} );
            tx_financeOrdersTo_Execute.wait().then( async reslveMsg => {
                console.log(`tx_requestOrderAXLUSDCfinancing is mined resolveMsg : `,reslveMsg);
                console.log(`*********************  financeOrdersTo_Execute End ***********************************`);
            });
        }

    }
    // await financeOrdersTo_Execute();
    console.log("");
    console.log("");


    const financeOrdersTo_Delete = async () => {
        console.log(`*********************  financeOrdersTo_Delete Start ***********************************`);

        const finance_Order_Nonces_ToDelete =  await AxelarFantomSatelite_instance.get_finance_Order_Nonces_ToDelete();
        console.log(` =-----> finance_Order_Nonces_ToDelete: `,finance_Order_Nonces_ToDelete);


        if (finance_Order_Nonces_ToDelete.length > 0)
        {
            console.log(` ===> WILL NOW RUN finance_Order_Nonces_ToDelete BECAUSE finance_Order_Nonces_ToDelete.length: ${finance_Order_Nonces_ToDelete.length} > 0 <===`);

            const tx_finance_Order_Nonces_ToDelete =  await AxelarFantomSatelite_instance.financeOrdersTo_Delete( {value: ethers.utils.parseEther("1.0")} );
            tx_finance_Order_Nonces_ToDelete.wait().then( async reslveMsg => {
                console.log(`tx_finance_Order_Nonces_ToDelete is mined resolveMsg : `,reslveMsg);
                console.log(`*********************  financeOrdersTo_Delete End ***********************************`);
            });
        }

    }
    // await financeOrdersTo_Delete();
    console.log("");
    console.log("");








    console.log(`********************************************************`);

  }
  
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
