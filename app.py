from flask import Flask, request, jsonify

from adapter import Adapter

from tweetAdapter import tweetAdapter

app = Flask(__name__)


@app.before_request
def log_request_info():
    app.logger.debug('Headers: %s', request.headers)
    app.logger.debug('Body: %s', request.get_data())


@app.route('/price', methods=['POST'])
def call_adapter():
    data = request.get_json()
    if data == '':
        data = {}
    adapter = Adapter(data)
    return jsonify(adapter.result)


@app.route('/grabTweet', methods=['POST'])
def call_tweet_adapter():
    data = request.get_json()
    if data == '':
        data = {}
    adapter = tweetAdapter(data)
    adapter.grabTweet()
    return jsonify(adapter.result)

@app.route('/test', methods=['GET'])
def tester():
    return jsonify("hello")


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port='8080', threaded=True)