module Physical
  module Project
    class ProjectRole < ActiveRecord::Base
      validates :name, :presence => true, :uniqueness => true, :allow_blank => false

      # see db/seeds.rb for roles
    end
  end
end