class RequestersController < ApplicationController
  def index
    @page = { title: params[:s] ? "Search results for #{params[:s]}" : 'Recently reviewed requesters' }
  end
end