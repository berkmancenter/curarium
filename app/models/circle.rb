class Circle < ActiveRecord::Base
  belongs_to :admin, class_name: 'User', foreign_key: 'admin_id'

  has_and_belongs_to_many :users

  has_many :trays, as: :owner

  def thumbnail_url
    url = '/missing_thumb.png'

    if trays.any?
      t = trays.first
      if t.images.present?
        url = t.images.first.thumbnail_url
      end
    end

    url
  end
end
