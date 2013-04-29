module Physical
  module Project
    class ProjectType < ActiveRecord::Base
      validates :title, :presence => true
      validates :description, :presence => true, :length => { :minimum => 1 }
    end
  end
end