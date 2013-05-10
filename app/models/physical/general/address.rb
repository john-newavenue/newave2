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
      

      FIELDS_PARAMS = [:line_1, :line_2, :city, :state, :zip_or_postal_code, :country, :other_details]
    end
  end
end