// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "https://github.com/smartcontractkit/chainlink/blob/develop/evm-contracts/src/v0.6/ChainlinkClient.sol";
import "https://github.com/smartcontractkit/chainlink/blob/develop/evm-contracts/src/v0.6/vendor/Ownable.sol";


contract chainlinkTwitter is ChainlinkClient, Ownable {
    address private oracle;
    bytes32 private jobId;
    uint256 private fee;
    string public tweet;
    
    constructor() public {
        //setPublicChainlinkToken();
        setChainlinkToken(0x326C977E6efc84E512bB9C30f76E30c160eD06FB);
        oracle = 0x293108E9eBA3c65EA0ae97c41A060fA75CAe4D71; // oracle address
        jobId = "b8f66e17e50141b888d6c42a450a23c4"; //job id
        fee = 1 * 10 ** 17; // 0.1 LINK
    }
    
    function bytes32ToString(bytes32 _bytes32) public pure returns (string memory) {
        uint8 i = 0;
        while(i < 32 && _bytes32[i] != 0) {
            i++;
        }
        bytes memory bytesArray = new bytes(i);
        for (i = 0; i < 32 && _bytes32[i] != 0; i++) {
            bytesArray[i] = _bytes32[i];
        }
        return string(bytesArray);
    }
    
    
    function grabtweet(string memory _tweetId) public {
        Chainlink.Request memory req = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);
        req.add("tId", _tweetId);
        sendChainlinkRequestTo(oracle, req, fee);
    }
    
    //callback function
    function fulfill(bytes32 _requestId, bytes32 _tweet) public recordChainlinkFulfillment(_requestId) {
        tweet = bytes32ToString(_tweet);
    }
}