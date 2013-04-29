class CreateProjectTable < ActiveRecord::Migration
  def change
    create_table(:projects) do |t|
      t.string :title, :null => false
      t.string :description, :default => ''

      t.timestamps
    end

    add_index :projects, :title
  end
end
