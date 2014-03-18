class Record < ActiveRecord::Base
  has_many :annotations, dependent: :destroy
  has_many :amendments, dependent: :destroy
  belongs_to :collection
end
