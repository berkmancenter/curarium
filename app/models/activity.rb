class Activity < ActiveRecord::Base
  belongs_to :activitiable

  belongs_to :circle
  belongs_to :user

  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'
end
