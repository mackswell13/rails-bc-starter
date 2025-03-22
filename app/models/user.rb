class User < ApplicationRecord
  validates :email_address, presence: true
  validates :username, presence: true

  has_many :sessions, dependent: :destroy
  has_many :store_relationships
  has_many :store, through: :store_relationships

  normalizes :email_address, with: ->(e) { e.strip.downcase }


  def is_owner_of?(store)
    store.store_relationships.exists?(user_id: self.id, is_owner: true)
  end
end
