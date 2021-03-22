import requests
import os
import json

class tweetAdapter:
    base_url = 'https://min-api.cryptocompare.com/data/price'
    tweetId_params = ['tId', 'tweetId']

    def __init__(self, input):
        self.id = input.get('id', '1')
        self.request_data = input.get('data')
    
    def validate_request_data(self):
        if self.request_data is None:
            return False
        if self.request_data == {}:
            return False
        return True

    def auth(self):
        return os.environ.get("TWITTER_BEARER_TOKEN")

    def set_params(self):
        for param in self.tweetId_params:
            self.tweetId_param = self.request_data.get(param)
            if self.tweetId_param is not None:
                break

    def create_url(self):
        tweet_fields = "tweet.fields=lang,author_id"
        # Tweet fields are adjustable.
        # Options include:
        # attachments, author_id, context_annotations,
        # conversation_id, created_at, entities, geo, id,
        # in_reply_to_user_id, lang, non_public_metrics, organic_metrics,
        # possibly_sensitive, promoted_metrics, public_metrics, referenced_tweets,
        # source, text, and withheld
        ids = "ids=" + self.tweetId_param
        #ids = "ids=1372437344851214339"
        # You can adjust ids to include a single Tweets.
        # Or you can add to up to 100 comma-separated IDs
        url = "https://api.twitter.com/2/tweets?{}&{}".format(ids, tweet_fields)
        return url


    def create_headers(self, bearer_token):
        headers = {"Authorization": "Bearer {}".format(bearer_token)}
        return headers


    def connect_to_endpoint(self, url, headers):
        response = requests.request("GET", url, headers=headers)
        print(response.status_code)
        if response.status_code != 200:
            raise Exception(
                "Request returned an error: {} {}".format(
                    response.status_code, response.text
                )
            )
        return response.json()

    def result_success(self, data):
        self.result = {
            'jobRunID': self.id,
            'data': self.result, # was data
            'result': self.result,
            'statusCode': 200,
        }

    def grabTweet(self):
        bearer_token = self.auth()
        print(bearer_token)
        self.set_params()
        url = self.create_url()
        headers = self.create_headers(bearer_token)
        json_response = self.connect_to_endpoint(url, headers)
        # print(json.dumps(json_response, indent=4, sort_keys=True))
        self.result = json_response['data'][0]['text']
        self.result_success(json_response)
        # return self.josn_result
