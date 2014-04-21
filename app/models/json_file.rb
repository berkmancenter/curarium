class JsonFile < ActiveRecord::Base
  mount_uploader :path, CollectorUploader
  belongs_to :collection
end
