#encoding: utf-8
Snumkg::Application.routes.draw do
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
  

  #home routes
  root :to => 'home#index'
  get '/all', :to => 'home#all', :as => 'all'
  get '/sokkoji', :to => 'groups#sokkoji', :as => 'sokkoji'
  get 'everyday', :to => 'everyday_posts#index', :as => 'everyday'

  resources :everyday_posts, :only => [:create, :destroy]
  resources :everyday_comments, :only => [:create, :destroy]

  #admin routes
  get 'admin', :to => 'admin#index'
  get 'admin/groups/hide/:id', :to => 'admin/groups#hide', :as => 'hide_admin_group'
  get 'admin/boards/hide/:id', :to => 'admin/boards#hide', :as => 'hide_admin_board'
  namespace :admin do
    resources :users
    resources :groups
    resources :boards
  end

  get "contacts/index"
  get "contacts/password_confirmation"

  #login, logout
  get '/signin', :to => 'auth#signin', :as => 'signin'
  post '/authorize', :to => 'auth#authorize'
  post '/check_password', :to => 'contacts#check_password'
  get '/signup', :to => 'users#new'
  get '/signout', :to => 'auth#signout'

  #contacts
  get '/contacts', :to => 'contacts#index'
  get '/articles/password_confirmation/:group_id/:board_id/:id', :to => 'articles#password_confirmation', :as => 'article_password_confirmation'

  #like, unlike
  get '/unlike_article/:article_id', :to => 'unlikes#article', :as => 'unlike_article'
  get 'unlike_comment/:comment_id', :to => 'unlikes#comment', :as => 'unlike_comment'
  get '/like', :to => 'likes#create', :as => 'like'
  get '/unlike', :to => 'likes#destroy', :as => 'unlike'


  #image
  resources :pictures, only: [:show, :create, :destroy]

  #sokkogi attendance
  get '/attendance', :to => 'attendances#create', :as => 'create_attendance'
  get '/cancel_attendance', :to => 'attendances#destroy', :as => 'destroy_attendance'


  #alarm
  get '/alarms', :to => 'users#alarms', :as => 'user_alarms'

  #user profile
  get '/profile/:id', :to => 'profiles#show', :as => 'profile'
  #get '/profile_image/:id(.:thumb)', :to => 'profiles#get_profile_image', :as => 'profile_image'
  #post '/upload_profile_image', :to => 'profiles#upload_profile_image', :as => 'upload_profile_image'

  #profile comment 
  post 'profile/create_comment', :to => 'comments#create_profile_comment', :as => 'profile_comment'

  resources :users
  resources :comments, only:[:create, :destroy]
  resources :messages

  #search
  get '/search', :to => 'search#user_name', :as => 'search'
  get '/search_id', :to => 'search#user_id'

  #resources :profile_comments, only:[:create, :destroy]

  get '/group/:id', :to => 'groups#show', :as => 'group'

  scope 'group/:group_id/board' do
    resources ':board_id', :as => 'articles', :controller => 'articles'
  end

	#chatting
	get '/chat', :to => 'chat#index'
      

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
