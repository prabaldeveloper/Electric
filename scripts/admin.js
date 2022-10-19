// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");
// const { ethers } = require("hardhat")

async function main() {
  // const currentTimestampInSeconds = Math.round(Date.now() / 1000);
  // const ONE_YEAR_IN_SECS = 365 * 24 * 60 * 60;
  // const unlockTime = currentTimestampInSeconds + ONE_YEAR_IN_SECS;

  // const lockedAmount = hre.ethers.utils.parseEther("1");
  const accounts = await hre.ethers.provider.listAccounts();
  console.log("Accounts", accounts[0]);

  const admin = await hre.ethers.getContractFactory("AdminFunctions");
  const adminContract = await upgrades.deployProxy(admin, { intializer: 'initialize' });
  await adminContract.deployed();
  console.log("Admin Proxy", adminContract.address);


  await adminContract.updateSupplyApy(5);

  await adminContract.updateSupplyAPYIncentives(5);

  await adminContract.updateBaseBorrowRate(5);

  await adminContract.updateProtocolMargin(5);

  await adminContract.updateAMMs(5);

  await adminContract.updateMarginReservePercent(5);

  await adminContract.updateLiquidationRatio(80);

  await adminContract.updateProtocolFees(5);

  await adminContract.updateLiquidationPenalty(5);

  await adminContract.updateSlippageTolerance(5);

  await adminContract.updateInterestMarginCall(5);

  await adminContract.updateInterestLiquidation(5);

  // await adminContract.updateTreasuryContract(treasuryContract);

  // await adminContract.updateApproveAssetStatus(assetAddress, true);


  // console.log(
  //   `Lock with 1 ETH and unlock timestamp ${unlockTime} deployed to ${lock.address}`
  // );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
    })
