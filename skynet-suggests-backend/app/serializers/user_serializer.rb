class UserSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :repos
  has_many :suggestions, through: :repos
end
