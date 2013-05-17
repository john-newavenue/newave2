Newave2::Application.routes.draw do

  get "admin_controller/index"
  get "project_type/index"
  get "project_type/edit"
  # static pages
  root to: 'frontend/static_pages#home'

  # users 
  # devise_for :users do
  #   get '/users/sign_out' => 'devise/sessions#destroy'
  # end
  
  devise_for :users, :controllers => {
    :registrations => 'frontend/devise_custom/registrations',
    :invitations => "frontend/users/invitations"
  }
  match "/users/invitation" => "frontend/users/invitations#update", :as => "accept_invitation_set_password_patch", :via => "patch"
  match "/users/invitation" => "frontend/users/invitations#update", :as => "accept_invitation_set_password_put", :via => "put"

  # namespace :admin do
    # resources :project_type
  # end

  scope :module => 'frontend' do

    # static pages
    match '/about' => 'static_pages#about', :as => 'about', :via => 'get'
    match '/terms' => 'static_pages#terms', :as => 'terms', :via => 'get'
    match '/privacy' => 'static_pages#privacy', :as => 'privacy', :via => 'get'

    # TODO: create admin user and role manager
    scope :module => 'admin', :as => 'admin' do
      match '/admin' => 'admin#index', :via => 'get'
      resources :users, :path => '/admin/users'
    end

    resources :invitations, :as => "admin_invitations", :path => '/admin/invitations', :module => "admin"

    scope :module => 'dashboard' do
      match '/user/:username_slug' => 'user_dashboard#profile', :as => 'user_profile', :via =>'get'
      match '/pro/:proname' => 'pro_dashboard#profile', :as => 'pro_profile', :via =>'get'
    end

    scope :module => 'projects' do
      resources :projects, :path => "/project"
    end

    scope :module => 'vendors' do
      
      match '/v/:slug' => 'vendors#show', :as => 'vendor', :via => 'get'
      # match '/vendors/new' => 'vendors#new', :as => 'new_vendor', :via => 'get'
      # match '/vendors/create' => 'vendors#create', :as => 'vendors', :via => 'post'
      # match '/vendors/:slug/edit' => 'vendors#edit', :as => 'edit_vendor', :via => 'get'
      # match '/vendors/:slug' => 'vendors#show', :as => 'vendor', :via => 'get'
      # match '/vendors/:slug' => 'vendors#update', :via => 'put'
      # match '/vendors/:slug' => 'vendors#update', :via => 'patch'
      # match '/vendors/:slug' => 'vendors#destroy',  :via => 'delete'

      # match '/vendors/:slug' => 'vendors#show', :as => 'vendor', :via => 'get'
      # match '/vendors/:slug' => 'vendors#update', :as => 'vendor', :via => 'put'
      # match '/vendors/:slug' => 'vendors#update', :as => 'vendor', :via => 'patch'
      # match '/vendors/:slug' => 'vendors#destroy', :as => 'vendor', :via => 'delete'
      resources :vendors, :path => "/vendors/"
    end
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
