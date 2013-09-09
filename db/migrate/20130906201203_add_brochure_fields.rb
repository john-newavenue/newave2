class AddBrochureFields < ActiveRecord::Migration
  def up
    add_column :brochures, :is_published, :boolean, :default => true, :null => false
    add_attachment :brochures, :attachment
  end

  def down
    remove_column :brochures, :is_published
    remove_attachment :brochures, :attachment
  end
end
