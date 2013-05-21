module Logical
  class TablelessBase
    include ActiveModel::Validations
    include ActiveModel::Conversion
    extend ActiveModel::Naming

    def self.inspect
      "#<#{ self.to_s} #{ self.attributes.collect{ |e| ":#{ e }" }.join(', ') }>"
    end

    def self.attr_accessor(*vars)
      @attributes ||= []
      @attributes.concat( vars )
      super
    end

    def self.attributes
      @attributes
    end

    def initialize(attributes = {})
      attributes.each do |name, value|
        send("#{name}=", value)
      end
    end
    
    def persisted?
      false
    end

    def update_attribute(attribute,value)
      if self.class.attributes.include? attribute
        send("#{attribute}=", value)
      else
        raise "#{attribute} is not a valid attribute in #{self.class}"
      end
    end

    def update_attributes(attributes)
      attributes.each do |key, value|
        update_attribute(key, value)
      end
    end

  end
end