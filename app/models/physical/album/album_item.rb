module Physical
  module Album
    class AlbumItem < ActiveRecord::Base
      acts_as_paranoid # soft delete
      default_scope order('id ASC')

      belongs_to :album, :class_name => "Physical::Album::Album"
      belongs_to :asset, :polymorphic => true
    end
  end
end