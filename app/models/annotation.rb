class Annotation < ActiveRecord::Base

  belongs_to :user
  belongs_to :image

  has_one :work, through: :image

  has_many :tray_items
  has_many :trays, through: :tray_items

  validate :title, :body, :x, :y, :width, :height, presence: true
end
