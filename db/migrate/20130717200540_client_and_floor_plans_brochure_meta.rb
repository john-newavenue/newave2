class ClientAndFloorPlansBrochureMeta < ActiveRecord::Migration
  def change
    create_table :brochures do |t|
      t.string :title, :null => false
      t.integer :position, :default => 9999
      t.integer :type, :null => false # see model for types
      t.text :short_description
      t.text :long_description
      t.decimal :area, :precision => 7, :scale => 2
      t.decimal :number_of_bath, :precision => 2, :scale => 1
      t.decimal :number_of_bed, :precision => 2, :scale => 1
      t.boolean :has_loft, :default => false
      t.timestamps
    end
  end
end
