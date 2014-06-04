class CreateCategoryLocations < ActiveRecord::Migration
def change
  create_table :category_locations do |t|
    t.references :category
    t.references :location
  end
end
end
