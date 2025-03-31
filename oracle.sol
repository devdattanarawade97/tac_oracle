// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// Interface for the Stork Oracle function
interface IStork {
    function getTemporalNumericValueUnsafeV1(
        bytes32 id
    ) external view returns (StorkStructs.TemporalNumericValue memory value);
}

// Contract containing the definition of the returned struct
// (You might only need the struct definition itself)
contract StorkStructs {
    struct TemporalNumericValue {
        // slot 1
        // nanosecond level precision timestamp of latest publisher update in batch
        uint64 timestampNs; // 8 bytes
        // should be able to hold all necessary numbers
        uint256 quantizedValue; // scaled price value
    }
}

// Your contract that interacts with the Stork Oracle
contract YourPriceConsumer {
    IStork public immutable stork;
    address public immutable storkOracleAddress = 0xacC0a0cF13571d30B4b8637996F5D6D774d4fd62;

    // Asset IDs as strings (for clarity/reference)
    string public constant BTC_ASSET_ID_STRING = "BTC/USD";
    string public constant TON_ASSET_ID_STRING = "TON/USD";

    // Asset IDs converted to bytes32 (using keccak256 assumption - VERIFY WITH STORK DOCS)
    bytes32 public immutable BTC_ASSET_ID_BYTES32;
    bytes32 public immutable TON_ASSET_ID_BYTES32;

    // --- Events (Optional but good practice) ---
    event PriceDataFetched(
        bytes32 indexed assetId,
        uint64 timestampNs,
        int192 quantizedValue
    );

    constructor() {
        stork = IStork(storkOracleAddress);

        // Calculate bytes32 IDs in the constructor (assuming keccak256)
        // !! VERIFY THIS CONVERSION METHOD WITH STORK ORACLE DOCUMENTATION !!
        BTC_ASSET_ID_BYTES32 =0x7404e3d104ea7841c3d9e6fd20adfe99b4ad586bc08d8f3bd3afef894cf184de ;
        TON_ASSET_ID_BYTES32 =0xf9b6588474de3e3c87da6f54a5184ab7f76e01bb3405946558a50173583e2211;
    }

    /**
     * @notice Fetches the latest price data for BTC/USD from the Stork oracle.
     * @return value The TemporalNumericValue struct containing timestamp and quantized price.
     * @dev Remember the returned price is a scaled integer (quantizedValue). Check Stork docs for decimals.
     * @dev The function `getTemporalNumericValueUnsafeV1` might revert or return stale data.
     */
    function getBtcPriceData()
        public 
        view
        returns (StorkStructs.TemporalNumericValue memory value)
    {
        value = stork.getTemporalNumericValueUnsafeV1(BTC_ASSET_ID_BYTES32);
        // Optionally emit an event
        // emit PriceDataFetched(BTC_ASSET_ID_BYTES32, value.timestampNs, value.quantizedValue);
        return value;
    }

    /**
     * @notice Fetches the latest price data for TON/USD from the Stork oracle.
     * @return value The TemporalNumericValue struct containing timestamp and quantized price.
     * @dev Remember the returned price is a scaled integer (quantizedValue). Check Stork docs for decimals.
     * @dev The function `getTemporalNumericValueUnsafeV1` might revert or return stale data.
     */
    function getTonPriceData()
        public
        view
        returns (StorkStructs.TemporalNumericValue memory value)
    {
        value = stork.getTemporalNumericValueUnsafeV1(TON_ASSET_ID_BYTES32);
        // Optionally emit an event
        // emit PriceDataFetched(TON_ASSET_ID_BYTES32, value.timestampNs, value.quantizedValue);
        return value;
    }

    /**
     * @notice Helper function to get just the quantized BTC price.
     * @return quantizedPrice The scaled integer price value.
     */
    function getBtcQuantizedPrice() external view returns (uint256 quantizedPrice) {
        StorkStructs.TemporalNumericValue memory data = getBtcPriceData();
        return data.quantizedValue;
    }

     /**
     * @notice Helper function to get just the quantized TON price.
     * @return quantizedPrice The scaled integer price value.
     */
    function getTonQuantizedPrice() external view returns (uint256 quantizedPrice) {
        StorkStructs.TemporalNumericValue memory data = getTonPriceData();
        return data.quantizedValue;
    }
}