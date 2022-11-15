
// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
contract MarginStorage {

     struct Deposit {
        uint256 marginAmount;
        address assetAddress;
        uint256 marginReserve;
        uint256 leverage;
        uint256 loanAmount;
        uint256 repaidLoan;
        uint256 interestAccumulated;
        uint256 timestamp;
        // uint256 usedMargin;
        uint256 usedLoan;
        uint256 lossValue;
        uint256 gainValue;
        uint256 exitAmount;
    }

    mapping(address => mapping(address => Deposit)) public depositDetails;

    mapping(address => mapping(address => uint256)) public totalInterest;
   

}