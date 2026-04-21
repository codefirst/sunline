Rails.application.routes.draw do
  get 'scripts/:guid.sh', to: 'scripts#sh'
  get 'scripts/wrapped/:guid.sh', to: 'scripts#wrapped_sh', as: :wrapped_sh
  get 'scripts/search', to: 'scripts#search', as: :search
  get 'scripts/:id/logs.csv', to: 'scripts#csv', as: 'logs_csv'
  resources :scripts

  get 'hosts', to: 'hosts#index', as: :hosts
  get 'hosts/:hostname', to: 'hosts#show', hostname: /.+/, as: :host

  root 'top#index'

  resources :logs
  post 'scripts/:guid/log', to: 'logs#create'
  post 'scripts/archive/:id', to: 'scripts#archive', as: :archive_script
  post 'scripts/unarchive/:id', to: 'scripts#unarchive', as: :unarchive_script

  devise_for :users, controllers: { omniauth_callbacks: 'authentication' }
  devise_scope :user do
    get 'sign_in', to: 'authentication#login', as: :new_user_session
    delete 'sign_out', to: 'authentication#logout', as: :destroy_user_session
  end

  get '*not_found', to: 'application#render_404', constraints: ->(req) {
    req.path.exclude? 'rails/active_storage'
  }
end
