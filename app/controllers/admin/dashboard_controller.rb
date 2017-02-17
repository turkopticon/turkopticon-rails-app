class Admin::DashboardController < ApplicationController
  before_action -> { require_access_level :admin }

  def index
    @docs = Docs::Document.select(:id, :name).all
  end
end
