Newave2::Application.routes.draw do

  get "admin_controller/index"
  get "project_type/index"
  get "project_type/edit"
  # static pages
  

  # users
  devise_for :users do
    get '/users/sign_out' => 'devise/sessions#destroy'
    
  end
  
  namespace :admin do
    resources :project_type
  end

  scope :module => 'frontend' do

    # static pages
    root to: 'static_pages#home'
    match '/about' => 'static_pages#about', :as => 'about', :via => 'get'
    match '/terms' => 'static_pages#terms', :as => 'terms', :via => 'get'
    match '/privacy' => 'static_pages#privacy', :as => 'privacy', :via => 'get'

    scope :module => 'admin' do
      match '/admin' => 'admin#index', :as => 'admin', :via => 'get'
    end


    scope :module => 'projects' do
      resources :projects
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
