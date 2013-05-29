require 'azzet'

module Physical
  module Asset
    class ImageAsset < ActiveRecord::Base

      acts_as_azzet

    end
  end
end