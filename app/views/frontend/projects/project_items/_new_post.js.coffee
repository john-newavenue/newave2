# render the new post at the top of the feed


$('.project-feed[data-project-id="<%=project_item.project.id%>"]')
  .prepend('<%= escape_javascript(render :partial => "project_feed_item", :locals => {:project_item => project_item} ) %>')
  .find('.project-feed-item:first-child')
    .hide()
    .slideDown('medium')



# recreate the new post box
# $('.new-post-container[data-project-id="<%=project_item.project_id%>"]')
#   .replaceWith('<%= escape_javascript(render :partial => "frontend/projects/project_items/new_post", :formats => [:html], :locals => {:project_item => Physical::Project::ProjectItem.new(:project_id => project_item.project_id)} ) %>')
