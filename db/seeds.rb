# This file should contain all the work creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#
#
#class CreateActivities < ActiveRecord::Migration
#  def change
#    create_table :activities do |t|
#      t.references :user, index: true
#      t.string :activity_type
#      t.string :body
#      t.references :activitiable, polymorphic: true, index: true
#      t.timestamps null: false
#    end
#  end
#end
