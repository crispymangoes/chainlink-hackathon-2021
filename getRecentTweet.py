import requests
import os
import json

# To set your environment variables in your terminal run the following line:
# export 'BEARER_TOKEN'='<your_bearer_token>'

class getRecentTweet:
    user_params = ['handle', 'username']

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
        for param in self.user_params:
            self.user_param = self.request_data.get(param)
            if self.user_param is not None:
                break

    def create_url(self):
        query = "from:" + self.user_param
        # Tweet fields are adjustable.
        # Options include:
        # attachments, author_id, context_annotations,
        # conversation_id, created_at, entities, geo, id,
        # in_reply_to_user_id, lang, non_public_metrics, organic_metrics,
        # possibly_sensitive, promoted_metrics, public_metrics, referenced_tweets,
        # source, text, and withheld
        tweet_fields = "tweet.fields=author_id"
        url = "https://api.twitter.com/2/tweets/search/recent?query={}&{}".format(
            query, tweet_fields
        )
        return url


    def create_headers(self, bearer_token):
        headers = {"Authorization": "Bearer {}".format(bearer_token)}
        return headers


    def connect_to_endpoint(self, url, headers):
        response = requests.request("GET", url, headers=headers)
        print(response.status_code)
        if response.status_code != 200:
            raise Exception(response.status_code, response.text)
        return response.json()

    def result_success(self, data):
        self.result = {
            'jobRunID': self.id,
            'data': self.result, # was data
            'result': self.result,
            'statusCode': 200,
        }

    def grabRecent(self):
        bearer_token = self.auth()
        print(bearer_token)
        self.set_params()
        url = self.create_url()
        headers = self.create_headers(bearer_token)
        json_response = self.connect_to_endpoint(url, headers)
        # print(json.dumps(json_response, indent=4, sort_keys=True))
        
        # self.result = json_response['data'][0]['text']
        try:
            self.result = int(json_response['data'][0]['text'], 0) # add error check if python can't convert tweet to a number then have it return 0 which we know no user has the zero address
        except:
            self.result = 0
        self.result_success(json_response)
