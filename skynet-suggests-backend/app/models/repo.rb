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
        self.update(bundle_id: repo["bundleId"], analysis_status: "bundle created")
  end

  def get_analysis #possibly use time stamps + marker when creating and locating suggestions ex. Suggestion where marker = 0 && time_stamp within last 3 min
    response = RestClient.get("www.deepcode.ai/publicapi/analysis/#{self.bundle_id}", headers={"Session-Token": "338e2a442e9f189f8ca3705c97f5343ddcf5eec225d749398b5bd3f7a6f662a3"})
    parsed_response = JSON.parse(response)
    repo_status = parsed_response["status"]
    case repo_status
    when "FETCHING", "ANALYZING", "DC_DONE"
      self.update(analysis_status: "analysis in progress")
    when "DONE"
      repo_files = parsed_response["analysisResults"]["files"] 
      files_arr = repo_files.keys #files that have suggestions
      files_arr.each do |file| #loop over files
        marker_arr = repo_files["#{file}"].keys #marker matches error to suggestion
          marker_arr.each do |marker| #for every marker loop once
            highlight_arr = repo_files["#{file}"]["#{marker}"]
            highlight_arr.each do |highlight| #loop over code areas to highlight within each marker
              rows = highlight["rows"]
              cols = highlight["cols"]
              Suggestion.create(rows: rows, cols: cols, file: file, marker: marker, repo_id: self.id)
              #create half of suggestion with data from files
            end
          end
      end
      repo_suggestions = parsed_response["analysisResults"]["suggestions"]
      marker_arr = repo_suggestions.keys
      marker_arr.each do |matching_marker|
        key_arr = repo_suggestions["#{matching_marker}"].keys #[id, message, severity]
        id = repo_suggestions["#{matching_marker}"]["#{key_arr[0]}"]
        message = repo_suggestions["#{matching_marker}"]["#{key_arr[1]}"]
        severity = repo_suggestions["#{matching_marker}"]["#{key_arr[2]}"]
        Suggestion.where("marker = ?", matching_marker.to_i).each do |suggestion| #find and loop over suggestions with matching marker
          suggestion.update(dp_id: id, message: message, severity: severity, marker: nil)
          #fill in other half of suggestion with data from suggestions and set marker to nil
        end
      end
      self.update(analyzed: true, analysis_status: nil)
    when "FAILED"
      self.update(analysis_status: "analysis failed")
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

  #   {
  #     "0" => {
  #              "id" => "javascript%2Fdc%2FDisablePoweredBy",
  #         "message" => "Disable X-Powered-By header for your Express app (consider using Helmet middleware), because it exposes information about the used framework to potential attackers.",
  #        "severity" => 2
  #    },
  #     "1" => {
  #              "id" => "javascript%2Fdc%2FExtractPortToVariable",
  #         "message" => "Extract the port number hardcoded in \\\"Listening at localhost:3000\\\" to a variable.",
  #        "severity" => 1
  #    },
  #     "2" => {
  #              "id" => "javascript%2Fdc%2FPromiseNotCaughtGeneral",
  #         "message" => "No catch method for promise. This may result in an unhandled promise rejection.",
  #        "severity" => 1
  #    },
  #     "3" => {
  #              "id" => "javascript%2Fdc%2FUseArrowFunction",
  #         "message" => "Use arrow functions inside filter(). Arrow functions use lexical scoping to bind this.",
  #        "severity" => 1
  #    },
  #     "4" => {
  #              "id" => "javascript%2Fdc%2FUseArrowFunction",
  #         "message" => "Use arrow functions inside map(). Arrow functions use lexical scoping to bind this.",
  #        "severity" => 1
  #    },
  #     "5" => {
  #              "id" => "javascript%2Fdc%2FUseArrowFunction",
  #         "message" => "Use arrow functions inside forEach(). Arrow functions use lexical scoping to bind this.",
  #        "severity" => 1
  #    },
  #     "6" => {
  #              "id" => "javascript%2Fdc%2FUseArrowFunction%2Ftest",
  #         "message" => "Use arrow functions inside forEach(). Arrow functions use lexical scoping to bind this.",
  #        "severity" => 1
  #    },
  #     "7" => {
  #              "id" => "javascript%2Fdc%2FUseNumberIsNan",
  #         "message" => "Using isNaN may lead to unexpected results. Consider the more robust Number.isNaN instead.",
  #        "severity" => 2
  #    },
  #     "8" => {
  #              "id" => "javascript%2Fdc%2FUseStrictEquality",
  #         "message" => "Use === instead of == to compare to the value.",
  #        "severity" => 1
  #    },
  #     "9" => {
  #              "id" => "javascript%2Fdc%2FUseStrictEquality",
  #         "message" => "Use === instead of == to compare to null.",
  #        "severity" => 1
  #    },
  #    "10" => {
  #              "id" => "javascript%2Fdc%2FUseStrictEquality",
  #         "message" => "Use !== instead of != to compare to null.",
  #        "severity" => 1
  #    },
  #    "11" => {
  #              "id" => "javascript%2Fdc%2FUseStrictEquality",
  #         "message" => "Use !== instead of != to compare to the value.",
  #        "severity" => 1
  #    },
  #    "12" => {
  #              "id" => "javascript%2Fdc%2FUseStrictEquality",
  #         "message" => "Use === instead of == to compare to the result of -.",
  #        "severity" => 1
  #    },
  #    "13" => {
  #              "id" => "javascript%2Fdc%2FUseStrictEquality",
  #         "message" => "Use === instead of == to compare to 0.",
  #        "severity" => 1
  #    },
  #    "14" => {
  #              "id" => "javascript%2Fdc%2FUseStrictEquality",
  #         "message" => "Use === instead of == to compare to \\\"\\\".",
  #        "severity" => 1
  #    }
  # }