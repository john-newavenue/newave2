require 'admin/base_controller'

class Admin::ProjectTypeController < Admin::BaseController

  def index
    @project_types = Admin::ProjectType.all
  end

  def edit

  end

end
