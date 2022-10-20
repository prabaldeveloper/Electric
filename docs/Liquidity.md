# Contract for Liquidity pool
#### contract name - liquidity

> Contract for adding and removing the liquidity.
> Distributing the interest to the liquidity providers. 


## Methods

### supply

```solidity
function supply(address tokenAddress, uint256 amount) external {

}
```

> Add the liquidity to the pool


### withdraw

```solidity
function withdraw(address tokenAddress, uint256 amount) external {
    
}
```

> Removes the liquidity from the pool for a user.
> Transfer the interest accumulated to the user


### withdrawInterest

```solidity
function withdrawInterest(uint256 amount) external {

}
```

> Transfer the interest accumulated to the user.

### availableMarket
```solidity
function availableMarket() public view returns {

}
```

> Returns the supported asset market.


### totalSupply
```solidity
function totalSupply() public view returns {

}
```

> Returns the total liquidity provided on the pool

### availableLiquidity
```solidity
function availableLiquidity() public view returns {

}
```

> Returns the available liquidity across each pool




