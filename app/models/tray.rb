class Tray < ActiveRecord::Base
  belongs_to :owner, polymorphic: true
end
