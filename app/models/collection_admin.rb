class CollectionAdmin < ActiveRecord::Base
  self.primary_keys = :collection_id, :user_id

  belongs_to :collection
  belongs_to :admin, class_name: 'User', foreign_key: :user_id
end

