class RepoSerializer < ActiveModel::Serializer
  attributes :id, :nickname, :url
  has_one :user
  has_many :suggestions
end
