class DocsController < ApplicationController
  skip_before_action :require_login

  def show
    @doc = Docs::Document.find_by! name: params[:name]
  end
end