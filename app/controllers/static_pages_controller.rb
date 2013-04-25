class StaticPagesController < ApplicationController
  def home
    render :layout => 'application'
  end

  def about
  end

  def terms
  end

  def privacy
  end
end
