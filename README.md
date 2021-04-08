# Smart Contracts with Twitter Verification

With so many new NFT artists flooding into crypto, how can you be sure that an artist is who they claim to be? One solution is to use Chainlink Oracles to verify ownership of crypto addresses with Twitter. 

# Demo

Click [here](https://youtu.be/BdV3zOOZjCo) to view the demo for this project!

## How it works

The NFT artist will post a tweet of their crypto address. They then give the smart contract their twitter username. The smart contract sends this username to an oracle, who then gives this to a node that will utilize the twitter api to grab that users latest tweet, and return it to the smart contract. If the tweeted address matches the address that originally called the verification function, then the twitter user is verified.


## All the moving pieces

There are a couple of steps to get this going. For me I had to set up a Chainlink Node on Polygon's Mumbai testnet, then create a Python Flask API, and finally make the job spec for the node.

-The Flask API can be run by running app.py

-In order for the Python app to use the twitter api it needs a twitter bearer token. This token must be exported IN THE SAME TERMINAL THAT RUNS THE app.py. Use this command to export: 
```export TWITTER_BEARER_TOKEN=YOUR_TOKEN```

-The following command will be helpful to see if your API is working properly, run it in a terminal ```curl -X POST -H "content-type:application/json" "http://localhost:8080/grabRecent" --data '{ "id": 0, "data": { "handle": "crispiermangoes" } }'```

-The required job spec can be found under /Chainlink-node/grab-recent-job-spec.json

-The Chainlink node also needs a bridge that tells it where to call the appropriate external adapter endpoint. Since the Node runs in a docker object it can be tricky to find the correct IP addr(localhost won't work). To find my IP addr I used ```ip addr``` and grabbed the IP labeled eth0.


-The example smart contract can be found under /Solidity/twitterverify.sol

-To actually run your Chainlink node run ```cd ~/.chainlink-kovan && docker run -p 6688:6688 -v ~/.chainlink-kovan:/chainlink -it --env-file=.env smartcontract/chainlink:0.10.2 local n```

## How to work with the contract

The contract is running on Polygon's Mumbai testnet, so go to their [faucet](https://faucet.matic.network/) and get some matic and link.

Then go to the Remix IDE, and add this contract to your Deploy & Run transactions tab: 0x2FF309ba73a8d8f25414f7eE6Dc03579128Adfda(Note you will need to compile the twitterVerify.sol contract then go to the deploy tab and you can use the At Address field to interact with the existing contract).

Before you can call the verifyUser function, you need to approve the contract to spend your link, go to the mumbai testnet [explorer](https://explorer-mumbai.maticvigil.com/address/0x326C977E6efc84E512bB9C30f76E30c160eD06FB/write-contract), to the link contract, and to the Write contract tab. There you will see the ```approve``` function. Set _spender = 0x2FF309ba73a8d8f25414f7eE6Dc03579128Adfda,  and the _value to 100000000000000000. Note Link uses 18 decimals, so _value is only 0.1 Link.

Now that the contract is approved to spend your 0.1 Link, you can pass your twitter username into the verifyUser function and wait. As long as your latest tweet is the same polygon address you used to call verifyUser, then the verification will be successful. 

To check if the verification was successful, input your polygon address into the verificationMap. If ```verified``` is true, then you have done it!

## Future Development

Since the external adapter is built using Python, we can leverage Python's amazing Machine Learning Libraries to conduct more in depth verification of twitter users. The external adapter can run a TensorFlow model that predicts whether a twitter user is a bot or a human based off their tweet history, and twitter usage.

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate. 

## License
[MIT](https://choosealicense.com/licenses/mit/)
