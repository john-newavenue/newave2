class RenameBrochureTypeColumn < ActiveRecord::Migration
  def change
    rename_column :brochures, :type, :category
  end
end
