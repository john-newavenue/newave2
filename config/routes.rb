Newave2::Application.routes.draw do

  get "project_type/index"
  get "project_type/edit"
  # static pages
  root to: 'frontend/static_pages#home'

  
  devise_for :users, :controllers => {
    :registrations => 'frontend/devise_custom/registrations',
    :invitations => "frontend/users/invitations"
  }
  match "/users/invitation" => "frontend/users/invitations#update", :as => "accept_invitation_set_password_patch", :via => "patch"
  match "/users/invitation" => "frontend/users/invitations#update", :as => "accept_invitation_set_password_put", :via => "put"

  scope :module => 'frontend' do

    #
    # static pages
    #

    match '/about' => 'static_pages#about', :as => 'about', :via => 'get'

    match '/terms' => 'static_pages#terms', :as => 'terms', :via => 'get'
    %w(/about/terms /about/tos /tos).each do |p|
      match p => redirect('/terms'), :via => 'get'
    end

    match '/privacy' => 'static_pages#privacy', :as => 'privacy', :via => 'get'
    %w(/about/privacy /privacy-policy /about/privacy-policy).each do |p|
      match p => redirect('/privacy'), :via => 'get'
    end

    #
    # Static Pages
    #

    match '/crm' => 'crm/crm#index', :as => 'crm', :via => 'get'
    scope :module => 'crm', :as => 'crm' do
      resources :users, :path => '/crm/users'
      resources :vendors, :path => '/crm/vendors'
      resources :projects, :path => '/crm/projects'
    end

    resources :invitations, :as => "crm_invitations", :path => '/crm/invitations', :module => "crm"

    scope :module => 'users' do
      match '/u/:username_slug' => 'profiles#show', :as => 'user_profile', :via =>'get'
      resources :profiles, :path => 'user'
    end

    scope :module => 'projects' do
      resources :projects, :path => "/project"
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
    resources :uploads, :controller => "assets/uploads", :as => "uploads", :path => "uploads"

  end

end
