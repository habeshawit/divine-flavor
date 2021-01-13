Rails.application.routes.draw do

  resources :comments
  resources :ingredients
  resources :categories
  resources :recipes
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  root 'welcome#index'

  get '/my_recipes', to: 'users#my_recipes' #change to 'recipes#index'
  get '/search_recipes', to: 'recipes#search'
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
