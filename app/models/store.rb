class Store < ApplicationRecord
  validates :store_hash, presence: true, uniqueness: true
  validates :access_token, presence: true

  encrypts :access_token
end
