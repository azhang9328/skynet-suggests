class Repo < ApplicationRecord
  belongs_to :user
  has_many :suggestions, dependent: :destroy

  def bundle
    git_info = self.url.split('/').slice(3, 5)
    response = RestClient.post('https://www.deepcode.ai/publicapi/bundle', {owner: "#{git_info[0]}", repo: "#{git_info[1]}"}.to_json, headers={
      "Content-Type": "application/json",
      "Session-Token": "338e2a442e9f189f8ca3705c97f5343ddcf5eec225d749398b5bd3f7a6f662a3"
      })
      repo = JSON.parse(response)
      self.update(bundle_id: repo["bundleId"])
  end

  def analysis_status
    response = RestClient.get("www.deepcode.ai/publicapi/analysis/#{self.bundle_id}", headers={"Session-Token": "338e2a442e9f189f8ca3705c97f5343ddcf5eec225d749398b5bd3f7a6f662a3"})
    repo_files = JSON.parse(response)["analysisResults"]["files"]
    repo_suggestions = JSON.parse(response)["analysisResults"]["suggestions"]
    # files_arr = repo_files.keys 
    # files_arr.length.times do |i|
    #   file = files_arr[i]
    #   marker_arr = repo_files["#{files_arr[i]}"].keys
    #     marker_arr.length.times do |x|
    #       marker = marker_arr[i]
    #       rows = repo_files["#{files_arr[i]}"]["#{marker_arr[x]}"][0]["rows"]
    #       cols = repo_files["#{files_arr[i]}"]["#{marker_arr[x]}"][0]["cols"]
    #       Suggestion.create(rows: rows, cols: cols, file: file, marker: marker, repo_id: self.id)
    #     end
    # end

    suggestions_arr = repo_suggestions.keys
    suggestions_arr.length.times do |i|
      marker_arr = suggestions_arr[i]
      marker_arr = repo_suggestions["#{suggestions_arr[i]}"].keys 
      puts marker_arr
      Suggestion.where("marker = ?", marker_arr)
    end
  end 
end

# {"files":{"/pokemon-teams-frontend/src/index.js":{
#   "0":
#   [{"rows":[75,75],"cols":[5,56],"markers":[{"msg":[20,26],"pos":[{"rows":[75,75],"cols":[5,56]}]}]},
#   {"rows":[84,84],"cols":[5,43],"markers":[{"msg":[20,26],"pos":[{"rows":[84,84],"cols":[5,43]}]}]}
#   ]}},
#   "suggestions":{
    # "0":{
    #   "id":"javascript%2Fdc%2FPromiseNotCaughtGeneral",
    #   "message":"No catch method for promise. This may result in an unhandled promise rejection.",
    #   "severity":1}}}}%  

# {"files"=>{"/skynet-suggests-frontend/src/index.js"=>{
#   "0"=>[
#     {"rows"=>[165, 165], 
#       "cols"=>[5, 50], 
#       "markers"=>[{"msg"=>[20, 26], 
#       "pos"=>[{"rows"=>[165, 165], 
#       "cols"=>[5, 50]}]}]
#     }
#       ]
#   }
# }, "suggestions"=>{"0"=>{"id"=>"javascript%2Fdc%2FPromiseNotCaughtGeneral", "message"=>"No catch method for promise. This may result in an unhandled promise rejection.", "severity"=>1}}}}
  