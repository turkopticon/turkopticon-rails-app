Rails.application.routes.draw do

  get 'splash/index' # only used for initial testing

  root 'main#info'
  get 'install' => 'main#install'
  get 'rules' => 'main#rules'
  resources 'reviews'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
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