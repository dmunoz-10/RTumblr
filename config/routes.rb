Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  namespace :api do
    namespace :v1 do
      get '/users/genders', to: 'users#genders', as: 'users_genders'
      resources :users, except: :index
      post '/users/authenticate', to: 'authentication#authenticate',
                                 as: 'user_authenticate'
      get '/users/:id/leaders', to: 'users#leaders', as: 'user_leaders'
      get '/users/:id/followers', to: 'users#followers', as: 'user_followers'
      post '/users/:id/follow', to: 'users#follow', as: 'follow_user'
      delete '/users/:id/unfollow', to: 'users#unfollow', as: 'unfollow_user'
      get '/users/liked/posts', to: 'users#liked_posts', as: 'user_liked_posts'
      get '/users/liked/comments', to: 'users#liked_comments',
                                  as: 'user_liked_comments'

      resources :blogs, only: %i[create update destroy] do
        resources :posts do
          resources :comments
          post 'comments/:id/like', to: 'comments#like_comment',
                                    as: 'like_comment'
          delete 'comments/:id/unlike', to: 'comments#unlike_comment',
                                        as: 'unlike_comment'
          get 'comments/:id/users/likes', to: 'comments#liking_users',
                                       as: 'comment_liking_users'
        end
        post 'posts/:id/like', to: 'posts#like_post', as: 'like_post'
        delete 'posts/:id/unlike', to: 'posts#unlike_post', as: 'unlike_post'
        get 'posts/:id/users/likes', to: 'posts#liking_users',
                                     as: 'post_liking_users'
      end
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
