module ActivityBrowser

  class Query

    MAX_ITEMS_PER_PAGE = 30
    SAFE_TEXT_INPUT = /\A[A-Za-z0-9\ ,]+\z/
    SAFE_BOOLEAN_INPUT = /\A[0-1]\z/
    ALLOWED_PARAMS = [:page, :acat, :icat, :pp, :show_joined, :show_clipped, :show_uploaded]

    # @param [Array<String>] activity_category

    def initialize(params = {})
      @params = set_params(params)
      # @query = params[:query]
      # @order = params[:order]
    end

    def get_params
      @params
    end

    def set_params(params)
      
      out = {}

      ALLOWED_PARAMS.each do |ap|
        if params[ap] and SAFE_TEXT_INPUT.match params[ap]
          params[ap] = params[ap]
        else
          params[ap] = nil
        end
      end

      # pages
      out[:page] = params[:page].to_i > 0 ? params[:page].to_i : 1
      out[:pp] = (params[:pp].to_i > 0 and params[:pp].to_i <= MAX_ITEMS_PER_PAGE) ? params[:pp].to_i : MAX_ITEMS_PER_PAGE
      
      # activity category
      acat = []
      acat.push("joined") if params[:show_joined]
      acat.push("clipped") if params[:show_clipped]
      acat.push("uploaded") if params[:show_uploaded]
      out[:acat] = acat

      # idea category
      icat = []
      icat.push(params[:icat]) if params[:icat]
      out[:icat] = icat

      out

    end

    def get_results
      join_query = '
        LEFT OUTER JOIN "project_item_assets" AS "assets" ON "assets"."project_item_id" = "project_items"."id"
        LEFT OUTER JOIN "album_items" AS "album_items" ON "assets"."album_item_id" = "album_items"."id"
        LEFT OUTER JOIN "album_item_categories" AS "album_item_categories" ON "album_items"."category_id" = "album_item_categories"."id"
        LEFT OUTER JOIN "albums" AS "albums" ON "album_items"."album_id" = "albums"."id"
        LEFT OUTER JOIN "projects" AS "projects" ON "albums"."parent_id" = "projects"."id"
      '
      where_array = []
      where_array.push('("album_item_categories"."name" in (\'' + @params[:icat].join("','") + '\'))') unless @params[:icat].count == 0
      where_array.push('("project_items"."category" in (\'' + @params[:acat].join("','") + '\'))') unless @params[:acat].count == 0
      where_array.push('(( "albums"."parent_type" = \'Physical::Project::Project\' AND "projects"."private" IS FALSE) OR ("project_items"."project_id" IS NULL))')
      where_query = where_array.join(" AND ")

      order_query = '"project_items"."created_at" DESC'

      @results = Physical::Project::ProjectItem.joins(join_query).where(where_query).order(order_query).paginate(:page => @params[:page], :per_page => @params[:pp])
    end

    def compose_param_string
      {
        :current_page => @page,
        :total_pages => @total_pages,
        :activity_category => @activity_category,
        :idea_category => @idea_category
      }.to_param
    end

  end

end