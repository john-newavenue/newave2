class RolifyCreatePhysicalUserRoles < ActiveRecord::Migration
  def change
    create_table(:physical_user_roles) do |t|
      t.string :name
      t.references :resource, :polymorphic => true

      t.timestamps
    end

    create_table(:users_physical_user_roles, :id => false) do |t|
      t.references :user
      t.references :role
    end

    add_index(:physical_user_roles, :name)
    add_index(:physical_user_roles, [ :name, :resource_type, :resource_id ], :name => 'physical_user_roles_name_resource_type_and_id')
    add_index(:users_physical_user_roles, [ :user_id, :role_id ])
  end
end
