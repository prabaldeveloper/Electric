// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

contract AdminStorage {

    mapping(address => bool) public approvedAsset;

    uint256 internal supplyAPY;

    uint256 internal supplyAPYIncentives;

    uint256 internal baseBorrowRate;

    uint256 internal protocolMargin;

    uint256 internal amms;

    uint256 internal marginReservePercent;

    uint256 internal liquidationRatio;

    uint256 internal protocolFees;

    uint256 internal liquidationPenalty;

    uint256 internal slippageTolerance;

    uint256 internal interestMarginCall;

    uint256 internal interestLiquidation;

    address payable internal treasuryContract;


    //
    // This empty reserved space is put in place to allow future versions to add new
    // variables without shifting down storage in the inheritance chain.
    // See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
    //
    uint256[999] private ______gap;
}