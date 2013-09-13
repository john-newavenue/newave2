class RenameCreditUrl < ActiveRecord::Migration
  def change
    rename_column :album_items, :ciredit_url, :credit_url
  end
end
