// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "https://github.com/smartcontractkit/chainlink/evm-contracts/src/v0.6/ChainlinkClient.sol";
import "https://github.com/smartcontractkit/chainlink/evm-contracts/src/v0.6/vendor/Ownable.sol";


contract UniversalPriceFeed is ChainlinkClient, Ownable {
    address private oracle;
    bytes32 private jobId;
    uint256 private fee;
    uint256 public price;

    constructor() public {
        setPublicChainlinkToken();
        oracle = 0x2c54ff0b5389Bc648CEB8431aF9d4902DA2CA30f; // oracle address
        jobId = "d93174ce89874424a1791344ddc7a0c5"; //job id
        fee = 1.1 * 10 ** 18; // 1.1 LINK
    }

    function grabprice(string memory _from, string memory _to) public {
        Chainlink.Request memory req = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);
        req.add("from", _from);
        req.add("to", _to);
        req.add("path", "result");
        req.addInt("times", 100);
        sendChainlinkRequestTo(oracle, req, fee);
    }

    //callback function
    function fulfill(bytes32 _requestId, uint256 _price) public recordChainlinkFulfillment(_requestId) {
        price = _price;
    }
}