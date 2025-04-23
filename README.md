# FundMe Smart Contract

## Overview

FundMe is a Solidity smart contract that allows users to fund a project with ETH. The contract ensures that each donation meets a minimum USD value using Chainlink price feeds for ETH/USD conversion. Only the contract owner can withdraw the accumulated funds.

## Features

- **Minimum Donation Requirement**: Enforces a minimum donation of $5 USD worth of ETH
- **Chainlink Price Feeds**: Uses Chainlink oracles for accurate ETH/USD conversion rates
- **Owner-Only Withdrawal**: Only the contract owner can withdraw funds
- **Donation Tracking**: Keeps track of all funders and their donation amounts
- **Fallback Functions**: Automatically handles direct ETH transfers to the contract

## Contract Details

### State Variables

- `owner`: Address of the contract deployer who has withdrawal privileges
- `MIN_USD_ALLOWED`: Minimum donation amount in USD (5 USD, scaled to 18 decimals)
- `s_AmountAddressFunded`: Mapping to track how much each address has funded
- `s_funders`: Array of addresses that have funded the contract
- `s_priceFeed`: Chainlink price feed interface for ETH/USD conversion

### Functions

- `constructor(address priceFeed)`: Initializes the contract with the owner and price feed address
- `fund()`: Allows users to donate ETH (requires minimum USD value)
- `withdraw()`: Allows the owner to withdraw all funds and reset funder data
- `getOwner()`: Returns the address of the contract owner
- `getAmountAddressFunded(address)`: Returns the amount funded by a specific address
- `getFunder(uint256)`: Returns the address of a funder at a specific index

### Events

- `Withdrawal`: Emitted when the owner withdraws funds
- `FundersReset`: Emitted when the funders list is reset during withdrawal

### Modifiers

- `onlyOwner`: Restricts function access to the contract owner

## Dependencies

- Chainlink Aggregator V3 Interface for price feeds
- PriceConverter library for ETH to USD conversion

## Usage

### Funding the Contract

```solidity
// Send ETH with a value of at least $5 USD
fundMeContract.fund{value: 1000000000000000000}() // 1 ETH
```

### Withdrawing Funds (Owner Only)

```solidity
// Only the contract owner can call this
fundMeContract.withdraw()
```

### Getting Contract Information

```solidity
// Get the contract owner
address owner = fundMeContract.getOwner()

// Get amount funded by an address
uint256 amountFunded = fundMeContract.getAmountAddressFunded(userAddress)

// Get a funder at a specific index
address funder = fundMeContract.getFunder(0)
```

## Security Features

- Owner-only withdrawal protection
- Minimum donation requirement
- Proper validation of fund transfers
