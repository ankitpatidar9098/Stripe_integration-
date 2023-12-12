Rails.application.routes.draw do
  # get 'payments/new'
  # get 'payments/create'
  # resources :payments
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get 'payments/index'
  get 'payments/show'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  # config/routes.rb

root 'payments#index'

# config/routes.rb
# resources :tickets

resources :payments, only: [:index, :show] do
  post 'purchase', on: :member
end

  # Defines the root path route ("/")
  # root "articles#index"
end
