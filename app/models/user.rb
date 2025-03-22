class User < ApplicationRecord
  validates :email_address, presence: true
  validates :username, presence: true
  has_many :sessions, dependent: :destroy
  has_many :store, through: :store_relationships

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
