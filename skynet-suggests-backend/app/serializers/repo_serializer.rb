class RepoSerializer < ActiveModel::Serializer
  attributes :id, :nickname, :url, :analyzed, :bundle_id
  has_one :user
  has_many :suggestions
end
