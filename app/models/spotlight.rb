class Spotlight < ActiveRecord::Base
  extend FriendlyId

  friendly_id :waku_id

  belongs_to :user
end
