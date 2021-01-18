Rails.application.routes.draw do

  resources :comments

  resources :categories
  resources :recipes do
    resources :comments, only: [:new, :create, :index, :destroy]
    member do
      delete :delete_image_attachment
    end
  end

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" } 
  root 'welcome#index'

  get '/my_recipes', to: 'users#my_recipes' #change to 'user/:id/recipes' <--create nested routes
  # get '/search_my_recipes', to: 'recipes#search_my_recipes'
  # get '/search_all_recipes', to: 'recipes#search_all_recipes'
  get '/delete_recipe', to: 'recipes#destroy'
  devise_scope :user do get '/logout' => 'devise/sessions#destroy' end

  get '/add_recipe' => 'recipes#add_recipe'
  # delete '/delete_comment' => 'comments#destroy'

  resources :users do
    resources :recipes, only: [:new, :create, :index]
  end




  

  

  #possible nested route
  #'recipes/:id/comments'
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
