module Physical
  module Album
    class Album < ActiveRecord::Base
      belongs_to :parent, :polymorphic => true
    end
  end
end