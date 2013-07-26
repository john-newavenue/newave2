module Physical
  module Project
    class ProjectItem < ActiveRecord::Base

      #
      # fields:
      # id, body, deleted_at, created_at, updated_at

      #
      # relations
      #

      belongs_to :project, :class_name => "Physical::Project::Project"
      has_many :project_item_assets, :class_name => "Physical::Project::ProjectItemAsset"
      accepts_nested_attributes_for :project_item_assets

      #
      # validations
      #

      validates_associated :project, :project_item_assets

      #
      # behaviors
      #

      acts_as_paranoid

      #
      # scope
      #

      scope :public, -> { where('project_items.private is false')}
      scope :private, -> { where('project_items.private is true')}
      scope :none, -> { where('false') }

    end
  end
end