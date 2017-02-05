require 'api_constraints'

Rails.application.routes.draw do

  get 'splash/index' # only used for initial testing

  scope module: :api, defaults: { format: :json }, constraints: { subdomain: 'api' } do
    root 'main#index', as: :api_root
    resources :requesters, only: [:index, :show], param: :rid, module: :v2d0a, constraints: ApiConstraints.new(version: '2.0-alpha', default: true), as: :api_default_requesters
    get '*path', to: 'api#error'
  end

  constraints subdomain: '' do
    root 'main#info', as: :root

    resources :accounts, only: [:new, :create], param: :token do
      get :activate, on: :member
    end
    resources :sessions, only: [:new, :create, :destroy], path_names: { new: :login }
    resources :reviews
    resources :requesters, only: [:index, :show], param: :rid
    resources :comments, :flags, only: [:create, :update]

    namespace :mod do
      resources :dashboard, only: [:index]
      resources :flags, only: [:index, :show, :put, :update]
    end

    namespace :admin do
      resources :dashboard, only: [:index]
    end

    scope :ujs, defaults: { format: :ujs } do
      patch :new_comment, to: 'ujs#new_comment'
      patch :new_flag, to: 'ujs#new_flag'
    end

    get :install, to: 'main#install'
    get :rules, to: 'main#rules'
  end

  # get 'reg/change_email'
  # get 'reg/change_password'

end
