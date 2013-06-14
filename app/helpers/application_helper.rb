module ApplicationHelper

  def full_title(page_title)
    base_title = "New Avenue Homes"
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end

  # pluralize and remove the number; e.g., turn "Architect" to "Architects"
  def pluralize_without_number(word)
    pluralize(2, word).split(' ')[1..-1].join(' ')
  end

end
