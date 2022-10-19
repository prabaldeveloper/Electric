
// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "./access/Ownable.sol";
import "./utils/AdminStorage.sol";
contract AdminFunctions is  Ownable, AdminStorage {

    using AddressUpgradeable for address;
    using AddressUpgradeable for address payable;

    function initialize() public initializer {
        Ownable.ownable_init();
    }

    function updateSupplyApy(uint256 _supplyAPY) external onlyOwner {
        supplyAPY = _supplyAPY;
    }

    function updateSupplyAPYIncentives(uint256 _supplyAPYIncentives) external onlyOwner {
        supplyAPYIncentives = _supplyAPYIncentives;
    }

    function updateBaseBorrowRate(uint256 _baseBorrowRate) external onlyOwner {
        baseBorrowRate = _baseBorrowRate;
    }

    function updateProtocolMargin(uint256 _protocolMargin) external onlyOwner {
        protocolMargin = _protocolMargin;

    }

    function updateAMMs(uint256 _amms) external onlyOwner {
        amms = _amms;
    }

    function updateMarginReservePercent(uint256 _marginReservePercent) external onlyOwner {
        marginReservePercent = _marginReservePercent;

    }

    function updateLiquidationRatio(uint256 _liquidationRatio) external onlyOwner {
        liquidationRatio = _liquidationRatio;
    }

    function updateProtocolFees(uint256 _protocolFees) external onlyOwner {
        protocolFees = _protocolFees;
    }

    function updateLiquidationPenalty(uint256 _liquidationPenalty) external onlyOwner {
        liquidationPenalty = _liquidationPenalty;
    }

    function updateSlippageTolerance(uint256 _slippageTolerance) external onlyOwner {
        slippageTolerance = _slippageTolerance;

    }

    function updateInterestMarginCall(uint256 _interestMarginCall) external onlyOwner {
        interestMarginCall = _interestMarginCall;
    }

    function updateInterestLiquidation(uint256 _interestLiquidation) external onlyOwner {
        interestLiquidation = _interestLiquidation;
    }

    function updateTreasuryContract(address payable _treasuryContract) external onlyOwner {
        require(_treasuryContract.isContract(), "AdminFunctions: Address is not a contract");
        treasuryContract = _treasuryContract;
    }

    function updateApproveAssetStatus(address _assetAddress, bool _status) external onlyOwner {
        require(_assetAddress.isContract(), "AdminFunctions: Address is not a contract");
        approvedAsset[_assetAddress] = _status;

    }

    function getSupplyApy() public view returns(uint256) {
        return supplyAPY;
    }

    function getSupplyAPYIncentives() public view returns(uint256) {
        return supplyAPYIncentives;
    }

    function geBaseBorrowRate() public view returns(uint256) {
        return baseBorrowRate;
    }

    function getProtocolMargin() public view returns(uint256) {
        return protocolMargin;
    }

    function getAMMs() public view returns(uint256) {
        return amms;
    }

    function getMarginReservePercent() public view returns(uint256) {
        return marginReservePercent;
    }

    function getLiquidationRatio() public view returns(uint256) {
        return liquidationRatio;
    }

    function getProtocolFees() public view returns(uint256) {
        return protocolFees;
    }

    function getLiquidationPenalty() public view returns(uint256) {
        return liquidationPenalty;
    }

    function getSlippageTolerance() public view returns(uint256) {
        return slippageTolerance;
    }

    function getInterestMarginCall() public view returns(uint256) {
        return interestMarginCall;
    }

    function getInterestLiquidation() public view returns(uint256) {
        return interestLiquidation;
    }

    function getTreasuryContract() public view returns(address) {
        return treasuryContract;
    }

    function isAssetApproved(address _assetAddress) public view returns(bool) {
        return approvedAsset[_assetAddress];
    }
}