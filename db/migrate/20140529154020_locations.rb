class Locations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name, null: false
      t.string :description, null: false
      t.string :phone
      t.string :address, null: false
    end

  end
end
