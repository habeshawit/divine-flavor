Rails.application.routes.draw do

  resources :user_recipes, only: [:new, :create, :index, :destroy]
  resources :comments
  resources :friendships, only: [:create, :destroy]

  resources :categories
  resources :recipes do
    resources :comments, only: [:new, :create, :index, :destroy]
    member do
      delete :delete_image_attachment
    end
  end

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" } 
  root 'welcome#index'

  get '/my_recipes', to: 'users#my_recipes'
  get '/delete_recipe', to: 'recipes#destroy'
  devise_scope :user do get '/logout' => 'devise/sessions#destroy' end

  get '/add_recipe' => 'recipes#add_recipe'
  get '/my_favorites' => 'user_recipes#index'
  get '/update_bio' => 'users#update'
  get '/my_friends' => 'users#my_friends'

  resources :users do
    resources :recipes, only: [:new, :create, :index]
  end




  

  

  #possible nested route
  #'recipes/:id/comments'
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
