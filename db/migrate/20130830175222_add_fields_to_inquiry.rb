class AddFieldsToInquiry < ActiveRecord::Migration
  def change
    add_column :inquiries, :interested_in, :string
    add_column :inquiries, :location, :string
  end
end
