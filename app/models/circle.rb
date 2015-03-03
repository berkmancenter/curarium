class Circle < ActiveRecord::Base
  belongs_to :admin, class_name: 'User', foreign_key: 'admin_id'

  has_and_belongs_to_many :users

  has_many :trays, as: :owner
  has_many :spotlights

  has_many :circle_collections
  has_many :collections, through: :circle_collections

  has_many :activities, as: :activitiable

  validates :title, presence: true, uniqueness: true
  validates :description, presence: true

  scope :for_user, ->( user ) {
    where( "admin_id = ? OR id IN ( SELECT circle_id FROM circles_users WHERE user_id = ? ) OR NOT privacy = 'private'", user.id, user.id )
    #where( "admin_id = ? OR NOT ( privacy = 'private' )", user.id )
  }

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
