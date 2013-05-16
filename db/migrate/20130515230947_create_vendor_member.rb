class CreateVendorMember < ActiveRecord::Migration
  def change
    create_table :vendor_members do |t|
      t.integer :user_id
      t.integer :vendor_id
      t.timestamps
    end

    add_index :vendor_members, :user_id
  end
end
