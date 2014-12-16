class Annotation < ActiveRecord::Base
  belongs_to :user
  belongs_to :image

  has_one :work, through: :image
end
