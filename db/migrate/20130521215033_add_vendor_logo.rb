class AddVendorLogo < ActiveRecord::Migration
  def change
    add_attachment :vendors, :logo
  end
end
