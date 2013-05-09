class CreateAddress < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :line_1
      t.string :line_2
      t.string :city
      t.string :state
      t.string :zip_or_postal_code
      t.string :country
      t.string :other_details
    end

    add_column :projects, :address_id, :integer
  end
end
