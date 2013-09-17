class AddNumberOfStoriesToBrochures < ActiveRecord::Migration
  def change
    add_column :brochures, :number_of_stories, :integer
  end
end
