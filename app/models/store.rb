class Store < ApplicationRecord
  validates :store_hash, presence: true, uniqueness: true
  validates :access_token, presence: true

  has_many :store_relationships
  has_many :users, through: :store_relationships
  has_many :sessions

  encrypts :access_token
end
