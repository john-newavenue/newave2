# overrides devise/app/helpers/devise_helper.rb

module DeviseHelper
  
  def devise_error_messages!

    return "" if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join

    # sentence = I18n.t("errors.messages.not_saved",
    #                   :count => resource.errors.count,
    #                   :resource => resource.class.model_name.human.downcase)

    sentence = "Please correct the following:"

    html = <<-HTML

    <div id="error_explanation" class="alert-box alert">
      <p>#{sentence}</p>
      <ul class="disc">#{messages}</ul>
    </div>

    HTML

    html.html_safe
  end
end