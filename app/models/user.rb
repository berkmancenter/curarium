class User < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  has_secure_password
  has_many :annotations
  has_many :messages
  has_many :comments
  has_many :trays, as: :owner
end
