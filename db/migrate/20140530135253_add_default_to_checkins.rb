class AddDefaultToCheckins < ActiveRecord::Migration
  def change
    change_table :checkins do |t|
      t.change :checked_in, :boolean, default: true
    end
  end
end
