class AddResourcesToSections < ActiveRecord::Migration
  def change
    add_column :sections, :resources, :json, default: {'Collection'=>[],'Spotlight'=>[],'Tray'=>[],'Visualization'=>[], 'Record'=>[]}
  end
end
