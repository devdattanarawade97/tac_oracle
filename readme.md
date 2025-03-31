# Stork Oracle Price Consumer Example

This Solidity contract (`YourPriceConsumer.sol`) demonstrates fetching BTC/USD and TON/USD price data from a specific Stork oracle instance (`0xacC0a0cF13571d30B4b8637996F5D6D774d4fd62`).

It uses the `getTemporalNumericValueUnsafeV1` function from the Stork oracle interface.

## Key Functions

* `getBtcPriceData()` / `getTonPriceData()`: Returns the full price data struct (`TemporalNumericValue`), including timestamp and the scaled price (`quantizedValue`).
* `getBtcQuantizedPrice()` / `getTonQuantizedPrice()`: Returns only the scaled integer price (`quantizedValue`).

## !! IMPORTANT !!

1.  **Asset IDs (`bytes32`)**: The method used in this example to generate `bytes32` Asset IDs (`keccak256` of "ASSET/QUOTE") is **a placeholder guess and likely INCORRECT** for Stork. You **MUST** find the correct `bytes32` values or the correct generation method from the **official Stork Oracle documentation**.
2.  **Price Decimals**: The `quantizedValue` is a scaled integer. You **MUST** check the Stork documentation for the number of decimals for *each specific feed* (BTC/USD, TON/USD) to convert this value into a standard price.
3.  **"Unsafe" Function**: The `UnsafeV1` in the function name implies potential risks (e.g., stale data, reverts). Consult Stork docs for details.

## Usage

1.  **Verify & Update Code**: Replace the placeholder Asset ID logic with the correct method found in Stork's official documentation.
2.  **Deploy**: Deploy the contract.
3.  **Call Functions**: Interact with the contract to retrieve price data.
4.  **Interpret Price**: Use the correct decimals (from Stork docs) to understand the `quantizedValue`.

**Use this example only after verifying the Asset ID and decimal details with the official Stork Oracle documentation.**