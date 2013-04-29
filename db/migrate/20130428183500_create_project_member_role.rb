class CreateProjectMemberRole < ActiveRecord::Migration
  def change
    create_table(:project_members) do |t|
      t.integer :project_role_id, :null => false
      t.integer :project_id, :null => false
      t.integer :user_id, :null => false
      t.timestamps
    end

    create_table(:project_roles) do |t|
      t.string :name, :null => false
    end
  end
end