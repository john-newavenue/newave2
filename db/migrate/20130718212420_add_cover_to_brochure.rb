class AddCoverToBrochure < ActiveRecord::Migration
  def up
    add_attachment :brochures, :cover_image
  end

  def down
    remove_attachment :brochures, :cover_image
  end
end
