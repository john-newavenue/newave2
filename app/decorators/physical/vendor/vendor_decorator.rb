module Physical
  module Vendor
    class VendorDecorator < Draper::Decorator
      #include ActionView::Helpers::TextHelper

      def profile_logo_url
        object.logo.instance.logo_file_name == nil ? "http://placehold.it/137x150" : object.logo.url(:profile)
      end

    end
  end
end