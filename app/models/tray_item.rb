class TrayItem < ActiveRecord::Base
  belongs_to :tray

  belongs_to :image
  belongs_to :annotation

  def thumbnail_url
    if image.present?
      image.thumbnail_url
    elsif annotation.present?
      annotation.thumbnail_url
    end
  end
end
