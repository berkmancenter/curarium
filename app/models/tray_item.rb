class TrayItem < ActiveRecord::Base
  belongs_to :tray
  belongs_to :image
end
