Curarium::Application.routes.draw do
  resources :circles

  get 'about' => 'home#about', as: 'about'
  
  controller :sessions do
    post 'login' => :create
    post 'logout' => :destroy
  end

#  post 'users/message' => 'users#message', as: 'user_message'
#  post 'sections/message' => 'sections#message', as: 'section_message'

  resources :trays

  resources :users do
    resources :trays
  end

  resources :sections do
    resources :trays

#    resources :messages do
#      resources :comments
#    end
  end

  resources :tray_items do
    member do
      put 'move' => :move
      post 'copy' => :copy
    end
  end

  resources :spotlights

  resources :works do
    member do
      get 'thumb'
    end

    resources :amendments
    resources :annotations
  end
  
  resources :collections do
    post "ingest" => "collections#ingest", as: "ingest"
    get "add" => "collections#add", as: "add"
    post "upload" => "collections#upload", as: "upload"

    resources :works
  end
  
  get "/help" => "pages#help"
  get "/importhelp" => "pages#importhelp"

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
