class TrayItem < ActiveRecord::Base
  belongs_to :tray

  belongs_to :image
  belongs_to :annotation
end
