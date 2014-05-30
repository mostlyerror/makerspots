class CreateCheckins < ActiveRecord::Migration
  def change
    create_table :checkins do |t|
      t.references :user
      t.references :location
      t.boolean :checked_in
      t.timestamps
    end
  end
end
