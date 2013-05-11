module Physical
  module General
    class AddressDecorator < Draper::Decorator
      include ActionView::Helpers::TextHelper
      def to_full_display

        # if line_1 is present, we know that the form was validated,
        # so line_2, city, state, etc. should also exist
        line_1 = object.line_1
        if line_1.present? and not line_1.blank?
          output = []
          delim = "\n"
          output.push(object.line_1)
          output.push(object.line_2) if object.line_2.present?
          output.push("#{object.city}, #{object.state} #{object.zip_or_postal_code}")
          output.push(object.country)
          output.push(object.other_details) if object.other_details.present?
          simple_format(sanitize(output.join(delim), :tags => []))
        else
          ""
        end
      end
    end
  end
end