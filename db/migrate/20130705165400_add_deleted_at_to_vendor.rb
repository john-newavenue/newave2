class AddDeletedAtToVendor < ActiveRecord::Migration
  def change
    change_table :vendors do |t|
      t.timestamp :deleted_at
    end
  end
end
