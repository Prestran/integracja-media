Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'main#index'
  match '/users/:id/finish_signup' => 'users#show', via: [:get, :patch], :as => :finish_signup
  post 'main/login', to: 'main#login_handle', defaults: {format: :json}
  resources :users
end
