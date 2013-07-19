class AddSlugToBrochure < ActiveRecord::Migration
  def up
    add_column :brochures, :slug, :string
    Physical::General::Brochure.reset_column_information
    Physical::General::Brochure.all.each do |b|
      b.slug = b.title.parameterize
      b.save
    end
    change_column :brochures, :slug, :string, :null => true
  end
  def down
    remove_column :brochures, :slug
  end
end
