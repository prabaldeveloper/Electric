# Contract for Margin
#### contract name - Margin

> Contract for deposit, withdraw borrow and repay.


## Methods

### deposit

```solidity
function deposit(address tokenAddress, uint256 amount, uint256 leverage) external {

}
```
> Deposit in the margin account.

### withdraw

```solidity
function withdraw(address tokenAddress, uint256 amount) external {

}
```
> Withdraws the amount from the margin account to the wallet.

### borrow

```solidity
function borrow(address tokenAddress, uint256 amount) external {

}
```
> Borrow funds into the margin account.

### repay

```solidity
function repay(address tokenAddress, uint256 amount) external {

}
```
> User can also partially repay the loan.

