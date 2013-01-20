#encoding: utf-8
Snumkg::Application.routes.draw do
  #home routes
  root :to => 'home#index'
  get '/all', :to => 'home#all', :as => 'all'
  get '/sokkoji', :to => 'groups#sokkoji', :as => 'sokkoji'
  get '/everyday', :to => 'everyday_posts#index', :as => 'everyday'

  #매일매일
  resources :everyday_posts, :only => [:create, :destroy]
  resources :everyday_comments, :only => [:create, :destroy]
  get '/everyday/:page', :to => 'everyday_posts#page'

  #관리자 페이지
  get 'admin', :to => 'admin#index'
  get 'admin/groups/hide/:id', :to => 'admin/groups#hide', :as => 'hide_admin_group'
  get 'admin/boards/hide/:id', :to => 'admin/boards#hide', :as => 'hide_admin_board'
  namespace :admin do
    resources :users
    resources :groups do 
      post 'set_positions'
    end
    resources :boards
  end

  #연락처 모아보기
  get "contacts/index"
  get "contacts/password_confirmation"
  get 'contacts', :to => 'contacts#index'
  get '/articles/password_confirmation/:group_id/:board_id/:id', :to => 'articles#password_confirmation', :as => 'article_password_confirmation'

  #login, logout
  get '/signin', :to => 'auth#signin', :as => 'signin'
  post '/authorize', :to => 'auth#authorize'
  post '/check_password', :to => 'contacts#check_password'
  get '/signup', :to => 'users#new'
  get '/signout', :to => 'auth#signout'

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


  #polls
  resources :polls
  resources :options, :only => [:update]
  resources :votes, :only => [:create]

  #alarm
  get '/alarms', :to => 'users#alarms', :as => 'user_alarms'
  get '/change_alarm_state/:id', :to => "users#change_alarm_state", :as => "change_alarm_state"
  get '/new_alarm_count', :to => "users#new_alarm_count", :as => "new_alarm_count"


  #유저
  resources :users
  get 'profile/edit', :to => "users#edit", :as => "edit_profile"
  get "profile/:id(.:format)", :to => "users#show", :as => "profile" #프로필 페이지
  get 'profile_image/:id', :to => "users#profile_image"
  get 'profile_image_thumb/:id', :to => "users#profile_image_thumb"
  put 'update_additional_user_info', :to => "users#update_additional_user_info", :as => "update_additional_user_info"


  #코맨트
  resources :comments, only:[:create, :destroy]
  post 'profile/create_comment', :to => 'comments#create_profile_comment', :as => 'profile_comment' #프로필 코맨트

  #쪽지
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
