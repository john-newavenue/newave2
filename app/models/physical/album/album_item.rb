module Physical
  module Album
    class AlbumItem < ActiveRecord::Base
      #
      # assocations
      #
      belongs_to :album, :class_name => "Physical::Album::Album"
      belongs_to :asset, :polymorphic => true

      #
      # scopes
      #
      default_scope order('position ASC')

      #
      # behaviors
      #
      acts_as_paranoid # soft delete
      acts_as_taggable

    end
  end
end