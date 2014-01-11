class Record < ActiveRecord::Base
  has_many :annotations, dependent: :destroy
  belongs_to :collection
end
