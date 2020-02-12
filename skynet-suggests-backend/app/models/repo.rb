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

  #TO DO LIST 
  #- ANALYSIS CANNOT RUN IF NO BUNDLE
  #- ANALYSIS MUST ACCOUNT FOR DEEPCODE RETURNING DIFF STAGES
  #  CANNOT CREATE SUGGESTION IF STAGE != DONE
  def analysis_status #possibly use time stamps + marker when creating and locating suggestions ex. Suggestion where marker = 0 && time_stamp within last 3 min
    response = RestClient.get("www.deepcode.ai/publicapi/analysis/#{self.bundle_id}", headers={"Session-Token": "338e2a442e9f189f8ca3705c97f5343ddcf5eec225d749398b5bd3f7a6f662a3"})
    repo_files = JSON.parse(response)["analysisResults"]["files"] 
    repo_suggestions = JSON.parse(response)["analysisResults"]["suggestions"]
    files_arr = repo_files.keys #files that have suggestions
    files_arr.length.times do |i| #loop over files
      file = files_arr[i] 
      marker_arr = repo_files["#{files_arr[i]}"].keys #marker matches error to suggestion
        marker_arr.length.times do |x| #for every marker loop once
          marker = marker_arr[i] 
          highlight_arr = repo_files["#{files_arr[i]}"]["#{marker_arr[x]}"]
          highlight_arr.length.times do |i| #loop over code areas to highlight within each marker
            rows = highlight_arr[i]["rows"]
            cols = highlight_arr[i]["cols"]
            Suggestion.create(rows: rows, cols: cols, file: file, marker: marker, repo_id: self.id)
            #create half of suggestion with data from files
          end
        end
    end

    suggestions_arr = repo_suggestions.keys
    suggestions_arr.length.times do |i|
      matching_marker = suggestions_arr[i] #marker matching suggestion to error
      key_arr = repo_suggestions["#{suggestions_arr[i]}"].keys #[id, message, severity]
      id = repo_suggestions["#{suggestions_arr[i]}"]["#{key_arr[0]}"]
      message = repo_suggestions["#{suggestions_arr[i]}"]["#{key_arr[1]}"]
      severity = repo_suggestions["#{suggestions_arr[i]}"]["#{key_arr[2]}"]
      Suggestion.where("marker = ?", matching_marker.to_i).each do |suggestion| #find and loop over suggestions with matching marker 
        suggestion.update(dp_id: id, message: message, severity: severity, marker: nil)
        #fill in other half of suggestion with data from suggestions and set marker to nil
      end
    end

    self.update(analyzed: true)
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
  