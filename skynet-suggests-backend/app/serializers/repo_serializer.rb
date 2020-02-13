class RepoSerializer < ActiveModel::Serializer
  attributes :id, :nickname, :url, :analyzed, :analysis_status
  has_one :user
  has_many :suggestions
end
