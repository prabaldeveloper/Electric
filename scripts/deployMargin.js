const hre = require("hardhat");

async function main() {
    const accounts = await hre.ethers.provider.listAccounts();
    console.log("Account Address", accounts[0]);

    const margin = await hre.ethers.getContractFactory("Margin");
    const marginProxy = await upgrades.deployProxy(margin);
    // const marginProxy = await margin.deploy();
    // const marginProxy = margin.attach("0xDAd6Dc722a33797d21456cEd41484AAD9aBc8c4B");
    // await marginProxy.deployed();

    console.log("Margin Proxy Address", marginProxy.address);

    //deposit function testing
    await marginProxy.deposit("0x0000000000000000000000000000000000000000", "10000000",1,{
        value: "10000000"
    });

    await new Promise(res => setTimeout(res, 6000));

    console.log("Amount deposited");



    console.log(await marginProxy.depositDetails(accounts[0], "0x0000000000000000000000000000000000000000"));

    await marginProxy.withdraw("0x0000000000000000000000000000000000000000", "1000000");

    await new Promise(res => setTimeout(res, 6000));

    console.log("Amount withdrawn");

    await marginProxy.withdraw("0x0000000000000000000000000000000000000000", "49");

    
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    })