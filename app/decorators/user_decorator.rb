class UserDecorator < Draper::Decorator
  include ActionView::Helpers::TextHelper

  delegate_all

  def roles
    object.roles.map { |r| content_tag :span, r.name, :class => "label"}.join(" ").html_safe
  end

  def username_and_email
    simple_format("#{object.username}\n#{object.email}")
  end

  def invitation_sent_at
    object.invitation_sent_at
  end

  def project_count
    object.projects.count
  end

  def invited_by_id
    object.invited_by_id
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