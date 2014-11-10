class Image < ActiveRecord::Base
  belongs_to :work

  has_many :tray_items
  has_many :trays, through: :tray_items

  default_scope {
    order( 'id ASC' )
  }
end
