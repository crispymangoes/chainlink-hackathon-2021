// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "https://github.com/smartcontractkit/chainlink/blob/develop/evm-contracts/src/v0.6/ChainlinkClient.sol";
import "https://github.com/smartcontractkit/chainlink/blob/develop/evm-contracts/src/v0.6/vendor/Ownable.sol";


contract twitterverify is ChainlinkClient, Ownable {
    address private oracle;
    uint256 private fee;
    bytes32 private verifyUserJobId;
    
    struct userVerification{
        bytes32 requestId;
        bool verified;
        string twitterHandle;
    }
    
    mapping(address => userVerification) public verificationMap;
    // add event for when user verifies successfully
    event verificationSuccess(bytes32 requestId, string twitterHandle);
    // add event for when a verification fails
    event verificationFailed(bytes32 requestId);
    
    
    address public LINK_CONTRACT_ADDRESS = 0x326C977E6efc84E512bB9C30f76E30c160eD06FB;
    linkToken link = linkToken(LINK_CONTRACT_ADDRESS);
    
    constructor() public {
        //setPublicChainlinkToken();
        setChainlinkToken(0x326C977E6efc84E512bB9C30f76E30c160eD06FB);
        oracle = 0x293108E9eBA3c65EA0ae97c41A060fA75CAe4D71; // oracle address
        verifyUserJobId = "a066dce51a834fc7b11b729d0dc95025"; //job id
        fee = 1 * 10 ** 17; // 0.1 LINK
    }
    
    function setJobId( bytes32 _jobId ) external onlyOwner {
        verifyUserJobId = _jobId;
    }
    
    function verifyUser(string memory _userHandle) public returns(bytes32) {
        require(link.transferFrom(msg.sender, address(this), fee), 'transferFrom failed');
        verificationMap[msg.sender].verified = false;
        verificationMap[msg.sender].twitterHandle = _userHandle;
        Chainlink.Request memory req = buildChainlinkRequest(verifyUserJobId, address(this), this.fulfill_verify.selector);
        req.add("handle", _userHandle);
        verificationMap[msg.sender].requestId = sendChainlinkRequestTo(oracle, req, fee);
        return verificationMap[msg.sender].requestId;
    }
    
    //callback function for verification
    function fulfill_verify(bytes32 _requestId, uint256 _address) public recordChainlinkFulfillment(_requestId) {
        address user = address(_address);
        if ( user == address(0) ){
            emit verificationFailed(_requestId);
            revert("Address must be non zero.");
        }
        if ( verificationMap[user].requestId == _requestId ){
            verificationMap[user].verified = true;
            emit verificationSuccess(_requestId, verificationMap[user].twitterHandle);
        }
    }
}

interface linkToken{
        function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    }
