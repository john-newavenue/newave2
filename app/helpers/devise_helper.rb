# overrides devise/app/helpers/devise_helper.rb

module DeviseHelper
  
  def devise_error_messages!

    return "" if resource.errors.empty?

    # return only the first error of each field
    messages = ""
    resource.errors.messages.each { |k,v|
      messages += "<li>" + ActiveSupport::Inflector.titleize(k) + " #{v.first}" + "</li>"
    }

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