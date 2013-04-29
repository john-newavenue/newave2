module Physical
  module Project
    class ProjectRole < ActiveRecord::Base
      validates :name, :presence => true
    end
  end
end