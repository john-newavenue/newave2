class CreateVendorsTable < ActiveRecord::Migration
  def change

    create_table :vendors do |t|
      t.string  :name
      t.string  :slug
      t.text    :description
      t.string  :url
      t.integer :vendor_type_id
      t.timestamps
    end

    add_index :vendors, :name, :unique => true
    add_index :vendors, :slug, :unique => true

    create_table :vendor_types do |t|
      t.string  :name
      t.string  :slug, :unique => true
      t.text    :description
    end

    add_index :vendor_types, :name, :unique => true
    add_index :vendor_types, :slug, :unique => true

  end
end
