module Frontend
  module Vendors
    class VendorsController < ApplicationController
      
      before_filter :authenticate_user!, :only => [:new, :create, :edit, :update, :destroy]
      before_action :authorize_user, :only => [:new, :create, :edit, :update, :destroy]

      def index
        # TODO: something....
      end

      def new
        
      end

      def create

        render 'show'
      end

      def show
        
        @vendor = get_vendor
        
      end

      def edit
        # debugger
        @vendor = get_vendor
      end

      def update
        # debugger
        @vendor = get_vendor
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
            # debugger if params[:action] == 'update' and current_user.has_role? :vendor
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

    end
  end
end