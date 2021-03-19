"# chainlink-hackathon-2021" 
If running external adpater in a WSL, then in order for node running in docker to connect to that IP, need to specify teh ip address
In WSL terminal, run ip  addr
Then find eth0 and grab the inet address mine was 172.29.213.52

Helpful curl command to test adapter API
curl -X POST -H "content-type:application/json" "http://localhost:8080/" --data '{ "id": 0, "data": { "from": "ETH", "to": "USD" } }'

