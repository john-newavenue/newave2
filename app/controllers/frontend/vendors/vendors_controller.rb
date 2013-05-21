module Frontend
  module Vendors
    class VendorsController < ApplicationController
      layout 'vendors'
      
      before_filter :authenticate_user!, :only => [:new, :create, :edit, :update, :destroy]
      before_action :authorize_user, :only => [:new, :create, :edit, :update, :destroy]

      def index
        # TODO: something....
        @vendors = Physical::Vendor::Vendor.all
      end

      def new
        @vendor = Physical::Vendor::Vendor.new
      end

      def create
        @vendor = Physical::Vendor::Vendor.new(vendor_params)
        if @vendor.save
          flash[:notice] = "Vendor created successfully."
          redirect_to vendor_path(@vendor)
        else
          flash[:alert] = "We found some errors in your submission. Please correct them."
          render 'new'
        end
        
      end

      def show
        
        @vendor = get_vendor
        
      end

      def edit
        @vendor = get_vendor
      end

      def update
        @vendor = get_vendor
        @vendor.update_attributes(vendor_params)
        if @vendor.save
          flash[:notice] = "Your profile was updated successfully."

          redirect_to vendor_path(:slug => @vendor.slug)
        else
          flash[:alert] = "Something went wrong. Please fix any errors."
          render 'edit'
        end
      end

      def destroy
        # debugger
        @vendor = get_vendor
      end

      private

        def authorize_user
          # find_by_slug! throws ActiveRecord::NotFound error, processed by ApplicationController.not_found()
          @vendor = get_vendor
          # forbidden defined in ApplicationController         
          case params[:action]            
          when 'new', 'create', 'destroy' # allow project managers and admins
            forbidden unless can? :access, Physical::Vendor::Vendor
          when 'edit', 'update' # allow project managers, admins, and vendors
            forbidden unless can? :update, @vendor
          end
        end

        def get_vendor
          if params.has_key? :slug
            @vendor = Physical::Vendor::Vendor.find_by_slug!(params[:slug])
          elsif params.has_key? :id
            @vendor = Physical::Vendor::Vendor.find_by_id!(params[:id])
          end
        end

        def vendor_params
          params.require(:vendor).permit(:name, :description, :vendor_type_id, :logo)
        end

    end
  end
end