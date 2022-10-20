# Contract for Position
#### contract name - Position

> Contract for creating and closing positions.


## Methods

### createPosition

```solidity
function createPosition(address tokenAddress, address targetToken, uint256 amount) external {

}
```

> Users can create a position. 


### closePosition

```solidity
function closePosition(uint256 positionId) external {
    
}
```
> Closes the trade for the given positionId.

### addMargin

```solidity
function addMargin(uint256 positionId, uint256 amount) external {
    
}
```
> Add more margin to the already created position.


### moveMargin

```solidity
function moveMargin(uint256 positionId, uint256 amount) external {
    
}
```
> Move margin from the position to the margin account.


### liquidationPrice

```solidity
function liquidationPrice(uint256 margin, uint256 loanAmount) public view returns(uint256) {
    
}
```
> calculates the liquidation price.

### marginCallPrice

```solidity
function marginCallPrice(uint256 margin, uint256 marginRation, uint256 price) public view returns(uint256) {
    
}
```
> calculates the marginCall Price.
