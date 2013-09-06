class AddFeaturedWorkAlbum < ActiveRecord::Migration
  def up
    add_column :user_profiles, :featured_work_album_id, :integer
    add_index :user_profiles, :featured_work_album_id
    add_foreign_key :user_profiles, :albums, :column => 'featured_work_album_id'
    ::Physical::User::UserProfile.reset_column_information
    ::Physical::User::UserProfile.includes(:user).where('user_id IS NOT NULL').references(:user).each do |p|
      # puts "#{p.id} - #{p.user != nil and p.user.has_role?(:vendor) and p.featured_work_album == nil}" 
      if not(User.where(:id => p.user_id).empty?) and p.user.has_role?(:vendor) and p.featured_work_album == nil
        p.build_featured_work_album(:parent => p, :title => "Featured Work")
        p.save
      end
    end
  end

  def down
    remove_foreign_key :user_profiles, :column => 'featured_work_album_id'
    remove_index :user_profiles, :featured_work_album_id
    remove_column :user_profiles, :featured_work_album_id
  end
end
