module Physical
  module User
    class UserProfileDecorator < Draper::Decorator
      include ActionView::Helpers::TextHelper
      def id
        object.user_id
      end

      def full_name
        s = %w(first_name middle_name last_name).each_with_object([]) { |field, result| 
          v = eval "object.#{field}"
          result.push(v) if v.present?
        }.join(" ")
      end
    end
  end
end