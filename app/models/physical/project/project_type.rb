module Physical
  module Project
    class ProjectType < ActiveRecord::Base
      validates :title, :presence => true,  :uniqueness => true, :allow_blank => false
      validates :description, :presence => true, :length => { :minimum => 1 }, :allow_blank => false
    end
  end
end