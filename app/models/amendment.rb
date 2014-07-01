class Amendment < ActiveRecord::Base
  belongs_to :user
  #belongs_to :record RAILS SEEMS TO HAVE AN ISSUE WITH MODELS CALLED 'RECORD', WHICH AFFECTS ACTIVE RECORD ASSOCIATIONS
end
