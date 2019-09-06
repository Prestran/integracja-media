Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  devise_scope :user do
    authenticated :user do
      root 'main#index', as: :authenticated_root
    end
  
    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  match '/users/:id/finish_signup' => 'users#show', via: [:get, :patch], :as => :finish_signup
  post 'main/login', to: 'main#login_handle', defaults: {format: :json}
  resources :users
end
