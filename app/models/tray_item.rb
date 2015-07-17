class TrayItem < ActiveRecord::Base
  belongs_to :tray

  belongs_to :image
  belongs_to :annotation

  default_scope {
    order( 'updated_at DESC' )
  }

  def thumbnail_url
    if image.present?
      image.work.thumbnail_cache_url
    elsif annotation.present?
      annotation.work.thumbnail_cache_url
    end
  end
end
