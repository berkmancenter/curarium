Curarium::Application.routes.draw do

  
  concern :tray_owner do
    resources :trays
  end
  
  controller :sessions do
    get  'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  get "sessions/create"
  get "sessions/destroy"

  post 'users/message' => 'users#message', as: 'user_message'
  post 'sections/message' => 'sections#message', as: 'section_message'

  resources :users do
    concerns :tray_owner
  end

  resources :sections do
    concerns :tray_owner
    resources :messages do
      resources :comments
    end
  end

  resources :spotlights

  resources :records do
    resources :annotations
  end

  resources :collections do
    get "tag" => "collections#tag", as: "tag"
    get "treemap" => "collections#treemap", as: "treemap"
    get "thumbnail" => "collections#thumbnail", as: "thumbnail"
    post "check_key" => "collections#check_key", as: "check_key"
    post "ingest" => "collections#ingest", as: "ingest"
    resources :visualizations
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

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

# Example resource route with concerns:
#   concern :toggleable do
#     post 'toggle'
#   end
#   resources :posts, concerns: :toggleable
#   resources :photos, concerns: :toggleable

# Example resource route within a namespace:
#   namespace :admin do
#     # Directs /admin/products/* to Admin::ProductsController
#     # (app/controllers/admin/products_controller.rb)
#     resources :products
#   end
end
