module ApplicationHelper

  def full_title(page_title)
    base_title = "New Avenue Homes"
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end

  # pluralize and remove the number; e.g., turn "Architect" to "Architects"
  def pluralize_without_number(word)
    pluralize(2, word).split(' ')[1..-1].join(' ')
  end

  def user_icon_for(user, size = :tiny)
    # for sizes, see User model
    user = User.new if user == nil
    # debugger
    defaults = {
      :tiny => 'icons/user-default-icon.png',
      :profile => 'icons/user-default-icon-large.png'
    }
    user.profile.avatar.file? ? user.profile.avatar(size) : defaults[size]
  end

  alias_method :user_picture_for, :user_icon_for

end
