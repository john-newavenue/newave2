module Physical
  module User

    # def self.table_name_prefix
    #   'physical_user_'
    # end
  
    class User < ActiveRecord::Base
      rolify #:role_cname => 'Physical::User::Role'
      #rolify #:role_cname => 'Physical::User::User'
      # Include default devise modules. Others available are:
      # :token_authenticatable, :confirmable,
      # :lockable, :timeoutable and :omniauthable
      devise :database_authenticatable, :registerable,
             :recoverable, :rememberable, :trackable, :validatable

      validates :username, :presence => true, :allow_blank => false, :length => { :minimum => 1 , :maximum => 100},
                :format => { :with => /\A[A-Z0-9a-z\w\b\ \-\_\'\!&@#\.]+\z/i,
                  :message => "A valid username may contain only alphanumeric characters and common special characters." }
      validates :email, :presence => true, :allow_blank => false,
                :format => { :with => Devise.email_regexp, :message => "Please enter a valid email address."}
              

    end   
  end
end