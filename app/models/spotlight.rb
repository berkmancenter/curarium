class Spotlight < ActiveRecord::Base
  extend FriendlyId

  friendly_id :waku_id

  belongs_to :user
  belongs_to :circle

  scope :user_only, -> {
    where( circle_id: nil )
  }

  scope :circle_only, -> {
    where.not( circle_id: nil )
  }
end
