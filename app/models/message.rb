class Message < ActiveRecord::Base
  belongs_to :section
  belongs_to :user
  has_many :comments
end
