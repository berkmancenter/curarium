class Tray < ActiveRecord::Base
  belongs_to :owner, polymorphic: true

  has_many :tray_items

  has_many :images, through: :tray_items
  has_many :annotations, through: :tray_items

  def has_image_id?( id )
    tray_items.where( image_id: id ).count > 0
  end

  def has_annotation_id?( id )
    tray_items.where( annotation_id: id ).count > 0
  end
end
