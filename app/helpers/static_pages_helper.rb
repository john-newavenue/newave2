module StaticPagesHelper
  

  def render_blog_feed(number_of_entries = 10, format = "list", column_class = "large-4", source)
    
    # format => "list", "grid", "columns"
    # column_class => "large-4", "large-3"

    require 'feedzirra'

    feed = Feedzirra::Feed.fetch_and_parse(source)
    render(
      :template => 'frontend/static_pages/_blog_feed.html.erb',
      :locals => {
        :entries => feed.entries[0..(number_of_entries-1)],
        :format => format,
        :number_of_entries => number_of_entries,
        :column_class => column_class
      }
    ).to_s
  end

end
