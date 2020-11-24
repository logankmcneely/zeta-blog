Rails.application.routes.draw do
  root 'pages#home'
  get 'signup', to: 'users#new'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  resources :articles
  resources :categories
  resources :likes, only: [:create, :destroy]
  resources :users, except: [:new]
end
