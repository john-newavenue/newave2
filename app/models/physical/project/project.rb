module Physical
  module Project
    class Project < ActiveRecord::Base

      resourcify # lets rolify attach roles to this class

      validates :title, :presence => true, :length => { :minimum => 1 }
      validates :description, :presence => true, :allow_blank => false, :length => { :maximum => 1000 }

      belongs_to :address, :class_name => "Physical::General::Address"
    end
  end
end