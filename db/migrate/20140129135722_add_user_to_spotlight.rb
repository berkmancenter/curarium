class AddUserToSpotlight < ActiveRecord::Migration
  def change
    add_reference :spotlights, :user, index: true
  end
end
