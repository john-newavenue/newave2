Newave2::Application.routes.draw do

  get "admin_controller/index"
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

    # static pages
    match '/about' => 'static_pages#about', :as => 'about', :via => 'get'
    match '/terms' => 'static_pages#terms', :as => 'terms', :via => 'get'
    match '/privacy' => 'static_pages#privacy', :as => 'privacy', :via => 'get'

    # TODO: create admin user and role manager
    match '/admin' => 'admin/admin#index', :as => 'admin', :via => 'get'
    scope :module => 'admin', :as => 'admin' do
      resources :users, :path => '/admin/users'
      resources :vendors, :path => '/admin/vendors'
    end

    resources :invitations, :as => "admin_invitations", :path => '/admin/invitations', :module => "admin"

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
      match '/pro/:slug' => 'vendors#show', :as => 'vendor_profile', :via => 'get'
    end

    resources :albums, :controller => "albums/albums", :as => "media", :path => "media"
    resources :albums, :controller => "albums/albums", :as => "medium", :path => "media"
    resources :photos, :controller => "assets/photos", :as => "photos", :path => "photo"

  end

  

  # match '/about' => 'static_pages#about', :as => 'about', :via => :get
  # match '/terms' => 'static_pages#terns', :as => 'terns', :via => :get
  # match '/privacy' => 'static_pages#privacy', :as => 'privacy', :via => :get

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with 'rake routes'.

  # You can have the root of your site routed with 'root'
  # root to: 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
