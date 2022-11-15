
// import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./utils/MarginStorage.sol";
import "./access/ReentrancyGuard.sol";



// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;
//Issue in withdraw and deposit function need to update it after implementing the interest fn
contract Margin is MarginStorage, ReentrancyGuard {
    
    receive() external payable {}

    event Deposited(address userAddress, address assetAddress, uint256 marginAmount, uint256 leverage, uint256 depositedTime);

    event Withdrawn(address userAddress, address assetAddress, uint256 marginAmount);

    function deposit(address assetAddress, uint256 marginAmount, uint256 leverage) external payable {
        require(marginAmount > 0  && leverage <=4, "Margin: Invalid inputs");
        if(assetAddress == address(0)) {
            require(msg.value > 0, "Margin: Invalid inputs");
            marginAmount = msg.value;
            payable(address(this)).transfer(marginAmount);   
        }
        else {
            IERC20(assetAddress).transferFrom(msg.sender, address(this), marginAmount);
        }

        uint256 marginReserve = marginAmount * 500/10000;

        Deposit storage depositInfo = depositDetails[msg.sender][assetAddress];

        // If amount exists calculate interest accumulated so far
        //interest accumulated check
        depositInfo.interestAccumulated += getInterestAccumulated(msg.sender, assetAddress, depositInfo.loanAmount);
        depositInfo.assetAddress = assetAddress;
        depositInfo.marginAmount += (marginAmount-marginReserve);
        depositInfo.marginReserve += marginReserve;
        depositInfo.leverage += leverage;
        depositInfo.loanAmount += (marginAmount * leverage);
        depositInfo.timestamp = block.number;

        //Loan(Liquidity) should be there in the contract
        //liquidity check


        emit Deposited(msg.sender, assetAddress, marginAmount, leverage, block.timestamp);
    }

    function withdraw(address assetAddress, uint256 amountToWithdraw) external nonReentrant payable{

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