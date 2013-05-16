module Frontend
  module Vendors
    class VendorsController < ApplicationController
      
      before_filter :authenticate_user!, :only => [:new, :create, :edit, :update, :destroy]
      before_action :authorize_user, :only => [:new, :create, :edit, :update, :destroy]
      rescue_from ActiveRecord::RecordNotFound, :with => :not_found

      def index
        # TODO: something....
      end

      def new
        
      end

      def create

        render 'show'
      end

      def show

      end

      def edit

      end

      def update

      end

      def destroy

      end

      private

        def authorize_user
          # find_by_slug! throws ActiveRecord::NotFound error, processed by ApplicationController.not_found()
          @vendor = Physical::Vendor::Vendor.find_by_slug!(params[:slug]) if params.has_key? :slug
          # forbidden defined in ApplicationController         
          case params[:action]            
          when 'new', 'create', 'destroy' # allow project managers and admins
            forbidden unless can? :access, Physical::Vendor::Vendor
          when 'edit', 'update' # allow project managers, admins, and vendors
            forbidden unless can? :update, vendor
          end
        end

    end
  end
end