module Physical
  module General
    class Address < ActiveRecord::Base
      # TODO: test, validate addresses
      resourcify

      # line_1
      # line_2
      # city
      # state
      # zip_or_postal_code
      # country
      # other_details

      validates :line_1, :presence => true
      validates :city, :presence => true
      validates :state, :presence => true
      validates :zip_or_postal_code, :presence => true
      validates :country, :presence => true
      
      

      FIELDS_PARAMS = [:line_1, :line_2, :city, :state, :zip_or_postal_code, :country, :other_details]
    end
  end
end