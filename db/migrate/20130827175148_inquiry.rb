class Inquiry < ActiveRecord::Migration
  def change
    create_table :inquiries do |t|
      t.string      :category, :default => "contact_form", :null => false
      t.text        :submitted_from_url, :null => false
      t.references  :user, :null => true
      t.string      :first_name, :null => false
      t.string      :last_name, :null => false
      t.string      :phone_number
      t.string      :email, :null => false
      t.text        :message, :null => false
      t.string      :referral, :null => true

      t.timestamps
    end

    reversible do |dir|
      dir.up   { 
        add_foreign_key :inquiries, :users 
        execute "ALTER SEQUENCE inquiries_id_seq restart with 5000"
      }
      dir.down { 
        remove_foreign_key :inquiries, :users
      }
    end
  end
end
