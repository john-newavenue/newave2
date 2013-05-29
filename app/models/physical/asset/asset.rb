module Physical
  module Asset
    class Asset < ActiveRecord::Base
      belongs_to :azzet, :polymorphic => true
    end
  end
end