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
    placeholders = {
      :tiny => 'https://b6694dc98fc00ffe8b6d-3d8cead74be35266d0f147cdde9ccbfd.ssl.cf1.rackcdn.com/general/blank_user.png',
      :small => 'https://b6694dc98fc00ffe8b6d-3d8cead74be35266d0f147cdde9ccbfd.ssl.cf1.rackcdn.com/general/blank_user.png',
      :profile => 'icons/user-default-icon-large.png'
    }
    user.profile.avatar.file? ? user.profile.avatar(size) : placeholders[size]
  end

  alias_method :user_picture_for, :user_icon_for

  def vendor_logo_for(vendor, size = :profile)
    vendor = Physical::Vendor::Vendor.new if vendor == nil
    placeholders = {
      :profile => 'https://b6694dc98fc00ffe8b6d-3d8cead74be35266d0f147cdde9ccbfd.ssl.cf1.rackcdn.com/general/blank_vendor.png'
    }
    vendor.logo.file? ? vendor.logo(size) : placeholders[size]
  end

end
