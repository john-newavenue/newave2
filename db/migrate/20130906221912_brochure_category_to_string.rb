class BrochureCategoryToString < ActiveRecord::Migration
  def up
    change_column :brochures, :category, :string
  end

  def down
    change_column :brochures, :category, :integer
  end
end
