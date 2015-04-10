class User < ActiveRecord::Base
  extend FriendlyId

  friendly_id :email, :use => :slugged

  validates :email, presence: true, uniqueness: true

  has_many :collections, through: :collection_admins
  #has_and_belongs_to_many :collections

  has_and_belongs_to_many :circles

  has_many :annotations
  has_many :messages
  has_many :comments
  has_many :trays, as: :owner
  has_many :spotlights
  has_many :amendments

  has_many :activities, as: :activitiable

  # all trays in which user participates (including circles)
  def all_trays
    ctids = circles.map { |c| c.trays.pluck :id if c.trays.any? }.compact.flatten
    utids = trays.pluck :id
    Tray.find (ctids + utids).uniq
  end
end


