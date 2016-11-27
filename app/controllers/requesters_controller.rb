class RequestersController < ApplicationController
  def index
    @page = { title: params[:s] ? "Search results for #{params[:s]}" : 'Recently reviewed requesters' }
  end

  def show
    req   = Requester.cached_find_by(rid: params[:rid])
    @page = { requester: req, reviews: req.reviews.order(created_at: :desc), aggregates: req.cached_aggregates }
  end
end