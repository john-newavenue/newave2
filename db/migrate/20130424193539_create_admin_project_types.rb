class CreateAdminProjectTypes < ActiveRecord::Migration
  def change
    create_table(:admin_project_types) do |t|
      t.string :title, :null => false
      t.string :description
      t.timestamps
    end

    add_index :admin_project_types, :title, :unique => true
  end
end
