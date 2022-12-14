// Sources flattened with hardhat v2.12.0 https://hardhat.org

// File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.7.3


// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}


// File contracts/utils/MarginStorage.sol


pragma solidity ^0.8.0;
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


// File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.7.3


// OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)

pragma solidity ^0.8.0;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}


// File contracts/Margin.sol

// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;
//Issue in withdraw and deposit function need to update it after implementing the interest fn
contract Margin is MarginStorage, ReentrancyGuard {

    event Deposited(address userAddress, address assetAddress, uint256 marginAmount, uint256 leverage, uint256 depositedTime);

    event Withdrawn(address userAddress, address assetAddress, uint256 marginAmount);

    function deposit(address assetAddress, uint256 marginAmount, uint256 leverage) external payable {
        require(marginAmount > 0  && leverage <=4, "Margin: Invalid inputs");
        if(assetAddress == address(0)) {
            require(msg.value > 0, "Margin: Invalid inputs");
            marginAmount = msg.value;
            (bool sent, ) = address(this).call{ value: marginAmount}("");
            require(sent, "Margin: Failed to transfer");
        }
        
        else {
            IERC20(assetAddress).transferFrom(msg.sender, address(this), marginAmount);
        }

        uint256 marginReserve = marginAmount * 500/10000;

        Deposit storage depositInfo = depositDetails[msg.sender][assetAddress];

        // If amount exists calculate interest accumulated so far
        //interest accumulated check
        depositInfo.interestAccumulated += getInterestAccumulated(msg.sender, assetAddress, depositInfo.loanAmount);
        //depositInfo.assetAddress = 
        depositInfo.marginAmount += (marginAmount-marginReserve);
        depositInfo.marginReserve += marginReserve;
        depositInfo.leverage += leverage;
        depositInfo.loanAmount += (marginAmount * leverage);
        depositInfo.timestamp = block.number;

        //Loan(Liquidity) should be there in the contract
        //liquidity check


        emit Deposited(msg.sender, assetAddress, marginAmount, leverage, block.timestamp);
    }

    function withdraw(address assetAddress, uint256 amountToWithdraw) external payable{

        Deposit storage depositInfo = depositDetails[msg.sender][assetAddress];

        uint256 totalMargin = depositInfo.marginAmount + depositInfo.marginReserve - depositInfo.lossValue +
            depositInfo.gainValue;

        //loan given for input amount
        uint256 loanAllocated = (depositInfo.loanAmount * amountToWithdraw) / totalMargin;

        //interest on given loan
        uint256 interestAmount = getInterestAccumulated(msg.sender, assetAddress, loanAllocated);

        // uint256 maxWithdrawAmount = depositInfo.marginAmount + depositInfo.marginReserve - depositInfo.lossValue +
        //     depositInfo.gainValue - interestAmount;
        // require(maxWithdrawAmount > 0 && amountToWithdraw <= maxWithdrawAmount, "Margin: Insufficient amount");

        require(amountToWithdraw > interestAmount, "Margin: Insufficient amount");

        uint256 amountTransferred = amountToWithdraw - interestAmount;

        //Add interest to contract

        totalInterest[address(this)][assetAddress] += interestAmount;

        //Reduce withdraw amount from deposit both from the marginReserve and the marginAmount

        depositInfo.marginReserve -= (amountToWithdraw * 500/10000);

        depositInfo.marginAmount -= (amountToWithdraw - (amountToWithdraw * 500/10000));
        // Reset deposit after full withdraw
        if(depositInfo.marginAmount + depositInfo.marginReserve == 0)

        //Add loan amount to liquidity

        //Reduce paid interest
        //This should be checked again after implementing interest
        depositInfo.interestAccumulated -= interestAmount;

        if(assetAddress == address(0)) 
            payable(msg.sender).transfer(amountTransferred);
        else 
            IERC20(assetAddress).transfer(msg.sender, amountTransferred);

        emit Withdrawn(msg.sender, assetAddress, amountTransferred);
        
    }

    function borrow(address assetAddress, uint256 borrowAmount) external {
        Deposit storage depositInfo = depositDetails[msg.sender][assetAddress];
        require(depositInfo.marginAmount > 0, "Margin: Insufficient deposit");

        uint256 totalMargin = depositInfo.marginAmount + depositInfo.marginReserve - depositInfo.lossValue +
            depositInfo.gainValue;

        uint256 ltmRatio = (depositInfo.loanAmount + depositInfo.usedLoan + borrowAmount)/totalMargin;

        require(ltmRatio <= 4, "Margin: Cannot give more loan");

        //loan availability check  
        depositInfo.loanAmount += borrowAmount;

    }

    // source = 1, from external wallet
    // source = 2, from margin Account
    function repay(address assetAddress, uint256 repayAmount, uint256 source) external payable {

        Deposit storage depositInfo = depositDetails[msg.sender][assetAddress];
        require(depositInfo.loanAmount >= repayAmount, "Margin: Excess repaid amount");
        if(source == 1) {
            if(assetAddress == address(0))  {
                repayAmount = msg.value;
                (bool sent, ) = address(this).call{ value: repayAmount}("");
                require(sent, "Margin: Failed to transfer");
            }
            else {
                IERC20(assetAddress).transferFrom(msg.sender, address(this), repayAmount);
            }
        }
        //using the margin account
        else {
            require(depositInfo.marginAmount + depositInfo.marginReserve >= repayAmount, "Margin: Insufficient Margin");
            uint256 reserveAmount = repayAmount * 500/10000;
            depositInfo.marginAmount -= (repayAmount - reserveAmount);
            depositInfo.marginReserve -= reserveAmount;
        }
        depositInfo.repaidLoan += repayAmount;

        //whether to add the loan amount in the marginAmount??
        
    }

    function getInterestAccumulated(address userAddress, address assetAddress, uint256 loanAmount) public pure returns(uint256) {

        return 50;

    }



}
