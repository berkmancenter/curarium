class Comment < ActiveRecord::Base
  belongs_to :message
  belongs_to :user
  validates :body, presence: true
end
