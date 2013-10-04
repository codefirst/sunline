Sunline::Application.routes.draw do
  resources :scripts

  root 'top#index'

  resources :logs
  post 'scripts/:guid/log', controller: 'logs', action: 'create'

  devise_for :users, controllers: { omniauth_callbacks: 'authentication' }
  devise_scope :user do
    get 'sign_in', to: 'authentication#login', as: :new_user_session
    get 'sign_out', to: 'authentication#logout', as: :destroy_user_session
  end
  get ':controller/:action', controller: 'authentication'
end
