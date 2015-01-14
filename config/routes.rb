Rails.application.routes.draw do
  root 'landing#index'

  resources :users
  resources :sessions

  get '/login', to: 'sessions#new', as: 'login'
  get '/signup', to: 'users#new', as: 'signup'
  get '/account', to: 'users#edit', as: 'account'
  get '/dashboard', to: 'dashboard#index', as: 'dashboard'
  get '/dashboard/fetch_dashboard_data', to: 'dashboard#fetch_dashboard_data', as: 'fetch_dashboard_data'
  get '/import', to: 'dashboard#import', as: 'import'
  get '/privacy', to: 'landing#privacy', as: 'privacy'

  post '/csv_upload', to: 'csv#upload', as: 'csv_upload'
end
