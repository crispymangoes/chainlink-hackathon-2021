// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "https://github.com/smartcontractkit/chainlink/blob/develop/evm-contracts/src/v0.6/ChainlinkClient.sol";
import "https://github.com/smartcontractkit/chainlink/blob/develop/evm-contracts/src/v0.6/vendor/Ownable.sol";


contract grabRecentTweet is ChainlinkClient, Ownable {
    address private oracle;
    bytes32 private jobId;
    uint256 private fee;
    uint256 public tweet;
    uint256 public user;
    address public userAddr;
    
    constructor() public {
        //setPublicChainlinkToken();
        setChainlinkToken(0x326C977E6efc84E512bB9C30f76E30c160eD06FB);
        oracle = 0x293108E9eBA3c65EA0ae97c41A060fA75CAe4D71; // oracle address
        jobId = "a066dce51a834fc7b11b729d0dc95025"; //job id
        fee = 1 * 10 ** 17; // 0.1 LINK
    }
    
    
    function grabRecent(string memory _userHandle) public {
        user = uint256(msg.sender);
        userAddr = msg.sender;
        Chainlink.Request memory req = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);
        req.add("handle", _userHandle);
        sendChainlinkRequestTo(oracle, req, fee);
    }
    
    //callback function
    function fulfill(bytes32 _requestId, uint256 _address) public recordChainlinkFulfillment(_requestId) {
        tweet = _address;
    }
}