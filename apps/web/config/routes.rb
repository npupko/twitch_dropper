# Configure your routes here
# See: http://hanamirb.org/guides/routing/overview/
#
# Example:
# get '/hello', to: ->(env) { [200, {}, ['Hello from Hanami!']] }
mount Sidekiq::Web, at: '/sidekiq'
root to: 'users#index'
resources :users, only: %i[index show edit update destroy]
patch '/users/:id', to: 'users#update'
