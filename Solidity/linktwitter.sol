// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "https://github.com/smartcontractkit/chainlink/evm-contracts/src/v0.6/ChainlinkClient.sol";
import "https://github.com/smartcontractkit/chainlink/evm-contracts/src/v0.6/vendor/Ownable.sol";


contract linkTwitter is ChainlinkClient, Ownable {
    address private oracle;
    bytes32 private jobId;
    uint256 private fee;
    bytes32 public tweet;
    
    constructor() public {
        setPublicChainlinkToken();
        oracle = 0x2c54ff0b5389Bc648CEB8431aF9d4902DA2CA30f; // oracle address
        jobId = "d8a84c219de446a4a14be2a8e34ae7c4"; //job id
        fee = 1.1 * 10 ** 18; // 1.1 LINK
    }
    
    function grabtweet(string memory _tweetId) public {
        Chainlink.Request memory req = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);
        req.add("tId", _tweetId);
        sendChainlinkRequestTo(oracle, req, fee);
    }
    
    //callback function
    function fulfill(bytes32 _requestId, bytes32 _tweet) public recordChainlinkFulfillment(_requestId) {
        tweet = _tweet;
    }
}