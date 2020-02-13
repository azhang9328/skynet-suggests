require 'rest-client'
require 'json'
require 'awesome_print'
response = RestClient.get("www.deepcode.ai/publicapi/analysis/gh/christinamcmahon/travel-pin/a5ed7ad95d82842e9f3fe4933c15982d35ad07a2", headers={"Session-Token": "338e2a442e9f189f8ca3705c97f5343ddcf5eec225d749398b5bd3f7a6f662a3"})
parsed_response = JSON.parse(response)
file_arr = parsed_response["analysisResults"]["files"].keys
# file = "/travel-pin-frontend/node_modules/unsplash-js/dist/unsplash.js"
# file = "/travel-pin-frontend/node_modules/unsplash-js/lib/methods/currentUser.js"
# file = "/travel-pin-frontend/node_modules/unsplash-js/lib/methods/photos.js"
# file = "/travel-pin-frontend/node_modules/unsplash-js/lib/methods/search.js"
# file = "/travel-pin-frontend/node_modules/querystring/test/index.js"
# file = "/travel-pin-frontend/node_modules/querystringify/index.js"
# file = "/travel-pin-frontend/node_modules/lodash.get/index.js"
# file = "/travel-pin-frontend/node_modules/url-parse/dist/url-parse.js"

ap parsed_response["analysisResults"]["suggestions"], index: false