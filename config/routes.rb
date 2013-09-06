Newave2::Application.routes.draw do

  get "project_type/index"
  get "project_type/edit"

  root to: 'frontend/static_pages#home'
  match '/join' => 'frontend/static_pages#join', :via => 'get'

  
  devise_for :users, :controllers => {
    :registrations => 'frontend/devise_custom/registrations',
    :invitations => "frontend/users/invitations",
    :omniauth_callbacks => "frontend/users/authentications"
  }
  match "/users/invitation" => "frontend/users/invitations#update", :as => "accept_invitation_set_password_patch", :via => "patch"
  match "/users/invitation" => "frontend/users/invitations#update", :as => "accept_invitation_set_password_put", :via => "put"

  scope :module => 'frontend' do

    #
    # Static
    #

    match '/about' => 'static_pages#about', :as => 'about', :via => 'get'
    match '/how' => 'static_pages#how', :as => 'how', :via => 'get'
    match '/terms' => 'static_pages#terms', :as => 'terms', :via => 'get'
    match '/privacy' => 'static_pages#privacy', :as => 'privacy', :via => 'get'
    match '/team' => 'static_pages#team', :as => 'team', :via => 'get'
    match '/faqs' => 'static_pages#faqs', :as => 'faqs', :via => 'get'
    match '/investors' => 'static_pages#investors', :as => 'investors', :via => 'get'
    match '/jobs' => 'static_pages#jobs', :as => 'jobs', :via => 'get'
    match '/press' => 'static_pages#press', :as => 'press', :via => 'get'
    # legacy
    match '/about/how-it-works' => redirect('/how'), :via => 'get'
    match '/about/terms' => redirect('/terms'), :via => 'get'
    match '/about/privacy' => redirect('/privacy'), :via => 'get'
    match '/company/team' => redirect('/team'), :via => 'get'

    #
    # Inquiries
    #

    match '/contact' => "inquiries#new", :as => "new_inquiry", :via => 'get' # is also the contact info page
    match '/contact' => "inquiries#new", :as => "contact", :via => 'get' # is also the contact info page
    match '/contact/success' => "inquiries#success", :as => "inquiry_success", :via => 'get'
    match '/contact/a' => "inquiries#mad_lib_submit", :as => "inquiry_mad_lib_submit", :via => 'post'
    match '/contact/a/success' => "inquiries#mad_lib_success", :as => "inquiry_mad_lib_success", :via => 'get'
    resources :inquiries, :path => "/contact", :only => [:create], :as => 'inquiry'


    # legacy
    get '/model', to: redirect('/designs')
    get '/ideas/floorplans', to: redirect('/designs')
    get '/ideas/floorplans/:slug', to: redirect('/designs/%{slug}')
    get '/our-clients',  to: redirect('/clients')
    get '/our-clients/:slug', to: redirect('/clients/%{slug}')


    #
    # Marketing Pages, Mostly Static
    #

    scope :module => 'content' do

      # Architects

      match '/architect/:slug' => 'featured_architects#show', :as => 'featured_architect_with_slug', :via => 'get'
      resources :featured_architects, :path => '/architects', :as => 'featured_architects' do
        resource :architect_works, :path => '/featured-work', :as => 'work', :only => [:update, :edit, :index]
        match '/featured-work/new' => "architect_works#new_images", :as => 'new_images', :via => 'get'
        match '/featured-work/upload' => "architect_works#upload_images", :as => 'upload_images', :via => 'post'
      end

      # Design Examples

      match '/small-home-design/:slug' => 'brochure_floorplans#show', :as => 'brochure_floorplan_with_slug', :via => 'get', :constraint => { :slug => /[A-Za-z]+/}
      resources :brochure_floorplans, :path => '/small-home-designs', :as => 'brochure_floorplans' do
        match '/album/new' => "brochure_floorplans#new_images", :as => 'new_images', :via => 'get'
        match '/album/upload' => "brochure_floorplans#upload_images", :as => 'upload_images', :via => 'post'
      end

      # Client Stories

      match '/small-home-client/:slug' => 'brochure_clients#show', :as => 'brochure_client_with_slug', :via => 'get'
      resources :brochure_clients, :path => '/small-home-clients', :as => 'brochure_clients' do
        match '/album/new' => "brochure_clients#new_images", :as => 'new_images', :via => 'get'
        match '/album/upload' => "brochure_clients#upload_images", :as => 'upload_images', :via => 'post'
      end

    end

    #
    # Site Admin
    #

    match '/crm' => 'crm/crm#index', :as => 'crm', :via => 'get'
    scope :module => 'crm', :as => 'crm' do
      resources :users, :path => '/crm/users'
      resources :vendors, :path => '/crm/vendors'
      resources :projects, :path => '/crm/projects'
      resources :albums, :path => '/crm/albums' 
      resources :brochure_floorplans, :path => '/crm/floorplans', :except => [:show]
      resources :brochure_clients, :path => '/crm/clients/', :except => [:show]
      resources :featured_architects, :path => '/crm/featured-architects/', :except => [:show, :delete, :destroy, :new]
    end

    resources :invitations, :as => "crm_invitations", :path => '/crm/invitations', :module => "crm"

    scope :module => 'users' do
      match '/u/:username_slug' => 'profiles#show', :as => 'user_profile', :via =>'get'
      resources :profiles, :path => 'user'
    end

    scope :module => 'projects' do
      resources :projects, :path => "/project" do
        resources :project_items, :path => 'item', :as => 'item'
      end
    end

    resources :albums, :controller => "albums/albums", :as => "media", :path => "media"
    resources :albums, :controller => "albums/albums", :as => "medium", :path => "media"
    match '/media/:id/upload' => "albums/albums#upload", :as => "media_upload", :via => 'get'

    resources :album_items, :controller => "albums/album_items", :as => "item", :path => "item"
    match '/item/:id(/:slug)' => "albums/album_items#show", :as => "item2", :via => 'get'
    resources :uploads, :controller => "assets/uploads", :as => "uploads", :path => "uploads"

  end

end
