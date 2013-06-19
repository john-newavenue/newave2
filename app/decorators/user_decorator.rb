class UserDecorator < Draper::Decorator
  include ActionView::Helpers::TextHelper

  delegate_all

  def username_and_email
    simple_format("#{object.username}\n#{object.email}")
  end

  def project_count
    object.projects.count
  end

  def invited_by
    user = User.find_by_id(object.invited_by_id)
    user.username if user
  end

  def invited_by_slug
    user = User.find_by_id(object.invited_by_id)
    user.slug if user
  end



end