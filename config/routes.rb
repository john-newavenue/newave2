Newave2::Application.routes.draw do

  get "project_type/index"
  get "project_type/edit"

  root to: 'frontend/static_pages#home'
  match '/join' => 'frontend/static_pages#join', :via => 'get'

  
  devise_for :users, :controllers => {
    :registrations => 'frontend/devise_custom/registrations',
    :invitations => "frontend/users/invitations"
  }
  match "/users/invitation" => "frontend/users/invitations#update", :as => "accept_invitation_set_password_patch", :via => "patch"
  match "/users/invitation" => "frontend/users/invitations#update", :as => "accept_invitation_set_password_put", :via => "put"

  scope :module => 'frontend' do

    #
    # old routes, redirects
    #

    match '/model' => redirect('/'), :via => 'get'

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

    #
    # Static > Brochure
    #

    match '/floorplans' => 'static_pages#brochure_floorplans', :as => 'brochure_floorplans', :via => 'get'
    match '/floorplans/:slug' => 'static_pages#brochure_floorplan', :as => 'brochure_floorplan', :via => 'get'
    match '/clients' => 'static_pages#brocure_clients', :as => 'brochure_clients', :via => 'get'
    match '/clients/:slug' => 'static_pages#brochure_client', :as => 'brochure_client', :via => 'get'


    # old paths, redirect
    match '/about/how-it-works' => redirect('/how'), :via => 'get'
    match '/about/terms' => redirect('/terms'), :via => 'get'
    match '/about/privacy' => redirect('/privacy'), :via => 'get'
    match '/company/team' => redirect('/team'), :via => 'get'


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

    scope :module => 'vendors' do
      resources :vendors, :path => "/v/" do
        resources :staff
        
      end
      match '/architects' => 'vendors#index', :as => 'architects', :via => 'get', :vendor_type => 'Architect'
      match '/pro/:slug' => 'vendors#show', :as => 'vendor_profile', :via => 'get'
    end

    resources :albums, :controller => "albums/albums", :as => "media", :path => "media"
    resources :albums, :controller => "albums/albums", :as => "medium", :path => "media"
    match '/media/:id/upload' => "albums/albums#upload", :as => "media_upload", :via => 'get'

    resources :album_items, :controller => "albums/album_items", :as => "item", :path => "item"
    match '/item/:id(/:slug)' => "albums/album_items#show", :as => "item2", :via => 'get'
    resources :uploads, :controller => "assets/uploads", :as => "uploads", :path => "uploads"

  end

end
