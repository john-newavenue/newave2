module Physical
  module Album
    class Album < ActiveRecord::Base
      acts_as_paranoid

      belongs_to :parent, :polymorphic => true
      validates :parent_id, :presence => true, :allow_blank => false
      validates :parent_type, :presence => true, :allow_blank => false
      validates :title, :presence => true, :allow_blank => false
      validate :parent, :check_parent_valid

      has_many :items, :class_name => "::Physical::Album::AlbumItem", :source => :asset

      private

        def check_parent_valid

        end

    end
  end
end