class Admin::DashboardController < ApplicationController
  before_action -> { require_access_level :admin }

end
