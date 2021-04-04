# Smart Contracts with Twitter Verification

With so many new NFT artists flooding into crypto, how can you be sure that an artist is who they claim to be? One solution is to use Chainlink Oracles to verify ownership of crypto addresses with Twitter. 

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


## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)