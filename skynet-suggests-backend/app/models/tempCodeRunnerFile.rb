    require 'rest-client'
    require 'json'
    response = RestClient.post('https://www.deepcode.ai/publicapi/bundle', {owner: "azhang9328", repo: "skynet-suggests"}.to_json, headers={
      "Content-Type": "application/json",
      "Session-Token": "338e2a442e9f189f8ca3705c97f5343ddcf5eec225d749398b5bd3f7a6f662a3"
      })
      repo = JSON.parse(response)
      puts repo["bundleId"]