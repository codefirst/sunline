Sunline::Application.routes.draw do
  get 'scripts/:guid.sh', controller: 'scripts', action: 'sh'
  get 'scripts/wrapped/:guid.sh', controller: 'scripts', action: 'wrapped_sh', as: :wrapped_sh
  get 'scripts/grep/:id', controller: 'scripts', action: 'grep', as: :grep
  get 'scripts/:id/logs.csv', controller: 'scripts', action: 'csv', as: 'logs_csv'
  resources :scripts

  get 'hosts', controller: 'hosts', action: 'index', as: :hosts
  get 'hosts/:hostname', controller: 'hosts', action: 'show', hostname: /.+/, as: :host

  root 'top#index'

  resources :logs
  post 'scripts/:guid/log', controller: 'logs', action: 'create'
  post 'scripts/archive/:id', controller: 'scripts', action: 'archive', as: :archive_script
  post 'scripts/unarchive/:id', controller: 'scripts', action: 'unarchive', as: :unarchive_script

  devise_for :users, controllers: { omniauth_callbacks: 'authentication' }
  devise_scope :user do
    get 'sign_in', to: 'authentication#login', as: :new_user_session
    delete 'sign_out', to: 'authentication#logout', as: :destroy_user_session
  end
  get ':controller/:action', controller: 'authentication'

  get '*not_found' => 'application#render_404'
end
