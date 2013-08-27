module Physical
  module General
    class Inquiry < ActiveRecord::Base

      # fields: category, submitted_form_url, user, first_name, last_name, phone_number, email, message, referral

      #
      # behaviors
      #

      validates :category, :inclusion => { :in => %w(contact_form mad_lib_form) }
      validates :user, :allow_blank => true, :allow_nil => true, :inclusion => { :in => proc { ::User.all } }
      validates :first_name, :presence => true, :allow_nil => false, :allow_blank => false
      validates :last_name, :presence => true, :allow_nil => false, :allow_blank => false
      validates :phone_number, :allow_blank => true, :presence => false
      validates :referral, :allow_blank => true, :presence => false
      validates :email, :presence => true, :format => { :with => Devise.email_regexp, :message => "isn't valid"}
      validates :message, :allow_blank => false, :allow_nil => false, :presence => true

      before_validation :compose_message
      # after_create :send_to_zoho
      # after_create :send_to_staff

      #
      # relations
      #

      belongs_to :user, :class_name => "::User"

      #
      # validations
      #


      def compose_message
        if category == "mad_lib_form"
          self.message = <<-HEREDOC
My name is #{first_name} #{last_name}. My phone number is #{phone_number}
          HEREDOC
        end
        self.message
      end

      private

      def send_to_zoho
        raise 'Not implemented'
      end

      def send_to_staff
        raise 'Not implemented'
      end

    end
  end
end