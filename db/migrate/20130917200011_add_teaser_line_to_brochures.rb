class AddTeaserLineToBrochures < ActiveRecord::Migration
  def change
    add_column :brochures, :teaser_line, :string
  end
end
