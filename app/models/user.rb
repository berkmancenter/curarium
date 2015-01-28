class User < ActiveRecord::Base
  extend FriendlyId

  friendly_id :email, :use => :slugged

  validates :email, presence: true, uniqueness: true
  validates :bio, presence: true

  has_many :annotations
  has_many :messages
  has_many :comments
  has_many :trays, as: :owner
  has_many :spotlights
  has_many :amendments
end


