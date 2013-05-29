module Azzet
  def acts_as_azzet
    include InstanceMethods
    has_one :asset, :as => :azzet, :autosave => true, :dependent => :destroy, :class_name => "Physical::Asset::Asset"
    alias_method_chain :asset, :build
    
    asset_attributes = Physical::Asset::Asset.content_columns.map(&:name) 

    # define the attribute accessor method
    def azzet_attr_accessor(*attribute_array)
      attribute_array.each do |att|
        define_method(att) do
          asset.send(att)
        end
        define_method("#{att}=") do |val|
          asset.send("#{att}=",val)
        end
      end
    end

    azzet_attr_accessor(*asset_attributes)
  end
 
  module InstanceMethods
    def asset_with_build
      asset_without_build || build_asset
    end
  end
end

ActiveRecord::Base.extend Azzet