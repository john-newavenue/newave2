module Frontend
  module Crm
    class VendorsController < ApplicationController
      layout 'admin'
      
      before_filter :authenticate_user!
      before_action :authorize_user

      def index
        @vendors = Physical::Vendor::VendorDecorator.decorate_collection(Physical::Vendor::Vendor.all)
      end

      #TODO: migrate /v/new to here

      # def new
      #   @vendor = Physical::Vendor::Vendor.new
      # end

      # def create
      #   @vendor = Physical::Vendor::Vendor.new(vendor_params)
      #   if @vendor.save
      #     flash[:notice] = "Vendor created successfully."
      #     redirect_to vendor_path(@vendor)
      #   else
      #     flash[:alert] = "We found some errors in your submission. Please correct them."
      #     render 'new'
      #   end
        
      # end

      # def show
        
      #   @vendor = get_vendor
        
      # end

      # def edit
      #   @vendor = get_vendor
      # end

      # def update
      #   @vendor = get_vendor
      #   @vendor.update_attributes(vendor_params)
      #   if @vendor.save
      #     flash[:notice] = "Your profile was updated successfully."

      #     redirect_to vendor_path(:slug => @vendor.slug)
      #   else
      #     flash[:alert] = "Something went wrong. Please fix any errors."
      #     render 'edit'
      #   end
      # end

      # def destroy
      #   # debugger
      #   @vendor = get_vendor
      # end

      private

        def authorize_user
          forbidden unless can? :access, Physical::Vendor::Vendor
        end

    end
  end
end