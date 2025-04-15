// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@redstone-finance/evm-connector/contracts/data-services/MainDemoConsumerBase.sol";

contract Redstone is MainDemoConsumerBase {
    function getETHPrice() public view returns (uint256) {
        return getOracleNumericValueFromTxMsg(bytes32("ETH"));
    }

    function getTONPrice() public view returns (uint256) {
        return getOracleNumericValueFromTxMsg(bytes32("TON"));
    }
    // Optional: Override timestamp validation if needed
    // function isTimestampValid(uint256 receivedTimestamp) public pure override returns (bool) {
    //     return (block.timestamp - receivedTimestamp) < 120; // 2 mins
    // }
}
