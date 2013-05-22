class SetUserProjectStartIndices < ActiveRecord::Migration

  def up
    execute "ALTER SEQUENCE users_id_seq restart with 1500"
    execute "ALTER SEQUENCE projects_id_seq restart with 1500"
  end

  def down
    execute "ALTER SEQUENCE users_id_seq restart with 0"
    execute "ALTER SEQUENCE projects_id_seq restart with 0"
  end

end
