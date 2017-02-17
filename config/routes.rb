Curarium::Application.routes.draw do

  devise_for :users

  get 'about' => 'home#about', as: 'about'
  get 'bot' => 'home#bot', as: 'bot'

  controller :sessions do
    get 'logout' => :destroy, as: 'logout'
  end

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

#  post 'users/message' => 'users#message', as: 'user_message'
#  post 'sections/message' => 'sections#message', as: 'section_message'

  resources :trays

  match '/users/:user_id/spotlights/:id' => 'spotlights#options', :constraints => {:method => 'OPTIONS'}, via: [:options]  
  match '/users/:user_id/circles/:circle_id/spotlights/:id' => 'spotlights#options', :constraints => {:method => 'OPTIONS'}, via: [:options]  

  resources :spotlights

  resources :users do
    resources :trays
    resources :activities
    resources :spotlights

    resources :circles do
      resources :spotlights
    end
  end

  resources :circles do
    resources :trays
    resources :activities

    member do
      put 'join' => :join
      put 'leave' => :leave

      put 'addcol' => :addcol
    end
  end

  resources :activities

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

  resources :works do
    member do
      get 'original'
      get 'thumb'
      post 'set_cover'
    end

    resources :amendments
    resources :annotations
  end

  get 'works/:work_id/images/:index' => 'images#show', as: :work_image
  get 'works/:work_id?image=:index' => 'works#show', as: :work_surrogate
 
  resources :collection_fields

  resources :collections do
    resources :collection_fields
    resources :works

    member do
      get 'sample_work' => 'collections#sample_work', as: :sample_work
      get 'configure' => "collections#configure", as: :configure
      post 'reconfigure' => "collections#reconfigure", as: :reconfigure
    end
  end
  
  get "/help" => "pages#help"
  get "/importhelp" => "pages#importhelp"
  get "/terms" => "pages#terms"

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
