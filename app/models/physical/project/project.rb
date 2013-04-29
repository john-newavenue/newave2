module Physical
  module Project
    class Project < ActiveRecord::Base
      validates :title, :presence => true, :length => { :minimum => 1 }
      validates :description, :presence => true, :length => { :minimum => 1 }
    end
  end
end