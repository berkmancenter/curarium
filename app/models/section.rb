class Section < ActiveRecord::Base
  has_many :messages
  has_many :trays, as: :owner
end
