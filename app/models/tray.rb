class Tray < ActiveRecord::Base
  belongs_to :owner, polymorphic: true

  has_many :tray_items
  has_many :images, through: :tray_items
end
