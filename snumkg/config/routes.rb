#encoding: utf-8
Snumkg::Application.routes.draw do
  get "contacts/index"

  get "boards/index"

  get "boards/new"

  get "boards/edit"

  get "boards/show"

  get "sokkoji_articles/index"

  get "sokkoji_articles/show"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view' 
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'home#index'

  get '/signin', :to => 'auth#signin'
  post '/authorize', :to => 'auth#authorize'
  post '/check_password', :to => 'contacts#check_password'
  get '/signup', :to => 'users#new'
  get '/signout', :to => 'auth#signout'
  get '/contacts', :to => 'contacts#index'
  get '/articles/password_confirmation/:group_name/:board_name/:id', :to => 'articles#password_confirmation', :as => 'article_password_confirmation'

  get '/like_article/:article_id(.:format)', :to => 'likes#article', :as => 'like_article'
  get '/unlike_article/:article_id', :to => 'unlikes#article', :as => 'unlike_article'
  get 'like_comment/:comment_id', :to => 'likes#comment', :as => 'like_comment'
  get 'unlike_comment/:comment_id', :to => 'unlikes#comment', :as => 'unlike_comment'
  
  get '/attendance/:sokkoji_article_id', :to => 'attendances#create', :as => 'create_attendance'
  get '/cancel_attendance/:sokkoji_article_id', :to => 'attendances#destroy', :as => 'destroy_attendance'

  get '/alarms', :to => 'users#alarms', :as => 'user_alarms'


  get '/profile/:id', :to => 'profiles#show', :as => 'profile'
  get '/profile_image/:id', :to => 'profiles#get_profile_image', :as => 'profile_image'
  get '/thumbnail/:id', :to => 'profiles#get_thumbnail', :as => 'thumbnail_image'
  post '/images', :to => 'profiles#image', :as => 'images'

  post 'profile/create_comment', :to => 'comments#create_profile_comment', :as => 'profile_comment'

  resources :users
  resources :comments, only:[:create, :destroy]
  resources :groups

  resources :boards
  #resources :profile_comments, only:[:create, :destroy]

  scope ':group_name' do

      resources ':board_name', :as => 'articles', :controller => 'articles'
  end

  get ':group_name', :to => 'home#group'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
