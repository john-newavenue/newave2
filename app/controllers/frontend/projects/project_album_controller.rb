module Frontend
  module Projects
    class ProjectAlbumController < ::Frontend::Albums::AlbumsController
      

      def get_album
        projects = Physical::Project::Project.where(:id => params[:project_id])
        return not_found if projects.count == 0
        @album = projects.first.primary_album
      end
    end
  end
end
