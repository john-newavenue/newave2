class AddUserProfileFields < ActiveRecord::Migration

  class Physical::User::UserProfile < ActiveRecord::Base
    belongs_to :address, :class_name => "Physical::General::Address"
  end

  def change

    change_table :user_profiles do |t|
      t.text            :bio
      t.string          :website_title
      t.string          :website_url
      t.references      :address
    end

    Physical::User::UserProfile.reset_column_information

    # 2013-05-23 JM: It's less frustrating to deal with foreign keys in up/down
    # especially when models are going to be populated/depopulated.

    reversible do |dir|
      dir.up {
        change_table :user_profiles do |t|
          t.foreign_key :addresses, :dependent => :delete
        end
        Physical::User::UserProfile.all.each do |p|
          p.create_address
          p.save
        end
      }
      dir.down {
        addresses_to_delete = Physical::User::UserProfile.all.map(&:address_id)
        change_table :user_profiles do |t|
          t.remove_foreign_key :addresses
        end
        Physical::General::Address.where(:id=> addresses_to_delete).destroy_all
      }
    end

  end


end
