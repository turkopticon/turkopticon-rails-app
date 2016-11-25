require 'api_constraints'

Rails.application.routes.draw do

  get 'splash/index' # only used for initial testing

  scope module: :api, defaults: { format: :json }, constraints: { subdomain: 'api' } do
    # get 'aggregates', to: 'v2d0/aggregates#index', constraints: ApiConstraints.new(version: '2.0')
    root 'main#index', as: :api_root
    # get 'aggregates', to: 'v2d0a/aggregates#index', constraints: ApiConstraints.new(version: '2.0-alpha', default: true)
    # get 'aggregates', to: 'aggregates#error'
    resources :requesters, only: [:index, :show], param: :rid, module: :v2d0a, constraints: ApiConstraints.new(version: '2.0-alpha', default: true), as: :api_default_requesters
    get '*path', to: 'api#error'
    # resources :requesters, only: [:index, :show], param: :rid, as: :api_requesters
  end

  # constraints subdomain: 'admin' do
  #   scope module: 'admin' do
  #     root to: 'admin#index', as: :admin_root
  #   end
  # end

  constraints subdomain: '' do
    root 'main#info', as: :root

    resources :sessions, only: [:new, :create, :destroy], path_names: { new: :login }
    resources :reviews
    resources :requesters, only: [:index, :show], param: :rid
    resources :comments, only: [:create, :update]

    scope :ujs, defaults: { format: :ujs } do
      patch :new_comment, to: 'ujs#new_comment'
    end

    get :install, to: 'main#install'
    get :rules, to: 'main#rules'
  end

  # get 'reg/change_email'
  # get 'reg/change_password'

end


=begin
ActionController::Routing::Routes.draw do |map|
  map.connect '2016survey', :controller => "main", :action => "survey2016"
  map.connect 'forum', :controller => "forum", :action => "index"
  map.connect 'stats', :controller => "stats"
  map.connect 'mod', :controller => "mod"
  map.connect 'pri', :controller => "main", :action => "pri"
  map.connect 'issues', :controller => "main", :action => "issues"
  map.connect 'login', :controller => "reg", :action => "login"
  map.connect 'logout', :controller => "reg", :action => "logout"
  map.connect 'register', :controller => "reg", :action => "register"
  map.connect 'info', :controller => "main", :action => "info"
  map.connect 'ditz', :controller => "main", :action => "ditz"
  map.connect 'blog', :controller => "main", :action => "blog"
  map.connect 'feed', :controller => "main", :action => "blogfeed"
  map.connect 'help', :controller => "main", :action => "help"
  map.connect 'aves/:id', :controller => "main", :action => "averages"
  map.connect 'post/:id', :controller => "main", :action => "post"
  map.connect 'flag/:id', :controller => "main", :action => "flag"
  map.connect 'add_flag/:id', :controller => "main", :action => "add_flag"
  map.connect 'requesters', :controller => "main", :action => "requesters"
  map.connect 'all_requesters', :controller => "main", :action => "all_requesters"
  map.connect 'requesters.csv', :controller => "main", :action => "requesters", :format => "csv"
  map.connect 'settings', :controller => "reg", :action => "settings"
  map.connect 'hidden', :controller => "main", :action => "hidden"
  map.connect 'reviews_by_one_page/:id', :controller => "main", :action => "reports_by_one_page"
  map.connect 'admin', :controller => "admin", :action => "index"
  map.connect 'wth', :controller => "main", :action => "wth"
  map.connect 'requester_stats/:id', :controller => "main", :action => "requester_stats"
  map.connect 'attrs/:id', :controller => "main", :action => "requester_attrs"
  map.connect 'attrsv2/:id', :controller => "main", :action => "requester_attrs_v2"
  map.connect 'confirm/:hash', :controller => "reg", :action => "confirm"
  map.connect 'enable_commenting/:id', :controller => "mod", :action => "enable_commenting"
  map.connect 'disable_commenting/:id', :controller => "mod", :action => "disable_commenting"
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
=end