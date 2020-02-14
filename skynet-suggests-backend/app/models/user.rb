class User < ApplicationRecord
    has_many :repos, dependent: :destroy
    has_many :suggestions, through: :repos
    validates :name, uniqueness: true
end
