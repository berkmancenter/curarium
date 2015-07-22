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

  scope :for_user_by_anon, ->( user ) {
    where( "NOT privacy = 'private' AND ( admin_id = :user OR id IN ( SELECT circle_id FROM circles_users WHERE user_id = :user ) )", { user: user.id } )
  }

  # user is admin & cur is part
  # user is part & cur is admin
  # user is part & cur is part
  # user is admin & cur not part & !private
  # user is part & cur not admin & !private
  scope :for_user_by_current, ->( user, current_user ) {
    where( %{
( admin_id = :user AND :user = :current ) OR
( id IN ( SELECT circle_id FROM circles_users WHERE user_id = :user ) AND :user = :current ) OR
( admin_id = :user AND id IN ( SELECT circle_id FROM circles_users WHERE user_id = :current ) ) OR
( admin_id = :current AND id IN ( SELECT circle_id FROM circles_users WHERE user_id = :user ) ) OR
( id IN ( SELECT circle_id FROM circles_users WHERE user_id = :user ) AND id IN ( SELECT circle_id FROM circles_users WHERE user_id = :current ) ) OR
( admin_id = :user AND NOT ( privacy = 'private' ) ) OR
( id IN ( SELECT circle_id FROM circles_users WHERE user_id = :user ) AND NOT ( privacy = 'private' ) )
    }, { user: user.id, current: current_user.id } )
  }

  scope :visible_to_user, ->( user ) {
    where( "admin_id = :user OR id IN ( SELECT circle_id FROM circles_users WHERE user_id = :user ) OR NOT privacy = 'private'", { user: user.id } )
  }

  def has_user?( user )
    admin == user || users.exists?( user )
  end

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
