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
  root :to => 'home#index'

  get '/signin', :to => 'auth#signin'
  post '/authorize', :to => 'auth#authorize'
  get '/signup', :to => 'users#new'
  get '/signout', :to => 'auth#signout'

  get '/like_article/:article_id(.:format)', :to => 'like_articles#like', :as => 'like_article'
  get '/unlike_article/:article_id', :to => 'like_articles#unlike', :as => 'unlike_article'
  get 'like_comment/:comment_id', :to => 'like_comments#like', :as => 'like_comment'
  get 'unlike_comment/:comment_id', :to => 'like_comments#unlike', :as => 'unlike_comment'
  get 'like_comment_memeber/:comment_id', :to => 'like_comments#show', :as => 'like_comment_member'
  
  get '/alarms', :to => 'users#alarms', :as => 'user_alarms'

  post '/images', :to => 'users#image', :as => 'images'

  resources :users
  resources :comments, only:[:create, :destroy]

  scope ':tab_name' do
      resources ':board_name', :as => 'articles', :controller => 'articles'
  end

  get ':tab_name', :to => 'home#tab'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
