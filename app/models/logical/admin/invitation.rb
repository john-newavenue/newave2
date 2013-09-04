module Logical
  module Admin
    class Invitation
      include ActiveModel::Validations
      include ActiveModel::Conversion
      extend ActiveModel::Naming

      attr_accessor :first_name, :last_name, :username, :email, :project_role, :message, :vendor, :is_new_vendor, :new_vendor_name, :new_vendor_type

      validates :first_name, :blank => false, :presence => true
      validates :last_name, :blank => false, :presence => true
      validates :username, :presence => true, :length => { :minimum => 3 },
        :format => { :with => /\A[A-Z0-9a-z\w\b\ \-\_\'\!&@#\.]+\z/i,
        :message => "may contain only alphanumeric characters and common special characters." }
      validates :email, :presence => true,
        :exclusion => { :in => proc { User.all.map { |u| u.email }}, :message => "already associated with existing account."},
        :format => { :with => Devise.email_regexp, :message => "isn't valid"}
      validates :project_role, :presence => true, :inclusion => { :in => proc { Physical::Project::ProjectRole.all.map { |r| r.id.to_s }} }
      validate :validate_username_and_email
      

      def validate_username_and_email
        # delegate to the User model
        u = User.new(:username => username, :email => email)
        if !u.valid?
          errors.add(:username, u.errors[:username]) if u.errors[:username]
          errors.add(:email, u.errors[:email]) if u.errors[:email]
        end
      end

      def initialize(attributes = {})
        attributes.each do |name, value|
          send("#{name}=", value)
        end
      end
      
      def persisted?
        false
      end

      def send!(from_user)
        # send the invitation
        user = User.invite!({:email => email,:username => username }, from_user)
        # update user profile
        profile = user.profile
        profile.first_name = first_name
        profile.last_name = last_name
        profile.save
        # add user roles
        pr = Physical::Project::ProjectRole.find_by(:id=> project_role.to_i )
        user.add_role pr.to_user_role
      end

    end
  end
end