module Frontend
  module Vendors
    class StaffController < ApplicationController
      layout 'vendors'
      
      before_filter :authenticate_user!, :except => [:show, :index]
      before_action :authorize_user, :only => [:new, :create, :edit, :update, :destroy]

      def index
        @vendor = Physical::Vendor::Vendor.find_by_id(params[:vendor_id])
        @vendor_members = @vendor.members
        @added_vendor_member = Logical::Vendor::AddedVendorMember.new(:vendor_id => @vendor.id)

        @vendor = @vendor.decorate
      end

      def new
        #@vendor = Physical::Vendor::Vendor.new
      end

      def create
        @added_vendor_member = Logical::Vendor::AddedVendorMember.new(added_vendor_member_params)
        @vendor = Physical::Vendor::Vendor.find_by_id(params[:vendor_id])
        if @added_vendor_member.valid?
          @user = User.find_by_username(params[:added_vendor_member][:username])
          @vendor.add_member(@user) 
          flash[:notice] = "#{@user.username} added successfully."
          redirect_to vendor_staff_index_path(@vendor)
        else
          flash[:alert] = "We found some errors in your submission. Please correct them."
          @vendor_members = @vendor.members
          @vendor = @vendor.decorate
          render 'index'
        end

      end

      def show
        
        # @vendor = get_vendor
        
      end

      def edit
        # @vendor = get_vendor
      end

      def update
        # @vendor = get_vendor
        # @vendor.update_attributes(vendor_params)
        # if @vendor.save
        #   flash[:notice] = "Your profile was updated successfully."

        #   redirect_to vendor_path(:slug => @vendor.slug)
        # else
        #   flash[:alert] = "Something went wrong. Please fix any errors."
        #   render 'edit'
        # end
      end

      def destroy
        @vendor_member = Physical::Vendor::VendorMember.where(destroy_added_vendor_member_params)
        if @vendor_member.nil?
          flash[:alert] = "Something went wrong."
        else
          flash[:notice] = "Member removed."
          @vendor_member.first.destroy
        end
        redirect_to vendor_staff_index_path(:vendor_id => params[:vendor_id])
      end

      private

        def authorize_user
          @vendor = get_vendor
          forbidden unless can? :access, Physical::Vendor::Vendor or can? :update, @vendor
        end

        def get_vendor
          Physical::Vendor::Vendor.find_by_id(params[:vendor_id])
        end

        def added_vendor_member_params
          params.require(:added_vendor_member).permit(:vendor_id, :username)
        end

        def destroy_added_vendor_member_params
          params.permit(:vendor_id, :user_id)
        end

    end
  end
end