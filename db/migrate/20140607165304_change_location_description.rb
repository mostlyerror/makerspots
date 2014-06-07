class ChangeLocationDescription < ActiveRecord::Migration
  def change
    change_column :locations, :description, :text, null: false
  end
end
