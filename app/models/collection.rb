class Collection < ActiveRecord::Base
  before_create :generate_key
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :configuration, presence: true
  
  private
  def generate_key
    self[:key] = SecureRandom.base64
  end
  
end
