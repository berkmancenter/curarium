class CollectionAdmin < ActiveRecord::Base
  belongs_to :collection
  belongs_to :admin, class_name: 'User', foreign_key: :user_id
end

