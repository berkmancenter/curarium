class Collection < ActiveRecord::Base
  before_create :generate_key

  private
  def generate_key
    self[:key] = SecureRandom.base64
  end
  
end
