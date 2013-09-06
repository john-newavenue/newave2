class AddIdealForToBrochure < ActiveRecord::Migration
  def change
    add_column :brochures, :ideal_for, :text
  end
end
