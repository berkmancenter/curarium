class Annotation < ActiveRecord::Base
  belongs_to :user
  belongs_to :work
end
