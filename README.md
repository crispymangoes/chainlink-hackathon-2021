"# chainlink-hackathon-2021" 
If running external adpater in a WSL, then in order for node running in docker to connect to that IP, need to specify teh ip address
In WSL terminal, run ip  addr
Then find eth0 and grab the inet address mine was 172.29.213.52

Helpful curl command to test adapter API
curl -X POST -H "content-type:application/json" "http://localhost:8080/grabTweet" --data '{ "id": 0, "data": { "tId": "1373481408597872640" } }'

# Actually need to run this IN THE VENV the terminal that is running the app.py
# export TWITTER_BEARER_TOKEN=YOUR_TOKEN
# The quotes broke it for m

To run chainlink node go to C:// and run
cd ~/.chainlink-kovan && docker run -p 6688:6688 -v ~/.chainlink-kovan:/chainlink -it --env-file=.env smartcontract/chainlink:0.10.2 local n\
Keystore password is one saved in onepass