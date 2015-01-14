Rails.application.routes.draw do
  root 'landing#index'

  resources :users
  resources :sessions
  resources :reset_password, only: [:new, :show, :create, :update]

  get '/login', to: 'sessions#new', as: 'login'
  get '/signup', to: 'users#new', as: 'signup'
  get '/account', to: 'users#edit', as: 'account'
  get '/dashboard', to: 'dashboard#index', as: 'dashboard'
  get '/dashboard/fetch_dashboard_data', to: 'dashboard#fetch_dashboard_data', as: 'fetch_dashboard_data'
  get '/import', to: 'dashboard#import', as: 'import'
  get '/contact', to: 'dashboard#contact', as: 'contact'
  get '/privacy', to: 'landing#privacy', as: 'privacy'
  post '/user_feedback', to: 'dashboard#user_feedback'
end