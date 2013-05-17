module Logical
  module Admin
    class Invitation
      include ActiveModel::Validations
      include ActiveModel::Conversion
      extend ActiveModel::Naming


      attr_accessor :email, :project_role, :message

      validates :email, :presence => true,
        :exclusion => { :in => proc { User.all.map { |u| u.email }}, :message => "already associated with existing account."},
        :format => { :with => Devise.email_regexp, :message => "isn't valid"}

      validates :project_role, :inclusion => { :in => proc { Physical::Project::ProjectRole.all.map { |r| r.id.to_s }} }

      def initialize(attributes = {})
        attributes.each do |name, value|
          send("#{name}=", value)
        end
      end
      
      def persisted?
        false
      end
    end
  end
end