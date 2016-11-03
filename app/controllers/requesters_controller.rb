class RequestersController < ApplicationController
  def index
    @page = { title: params[:s] ? "Search results for #{params[:s]}" : 'Recently reviewed requesters' }
  end

  def show
    req   = Requester.by_rid(params[:rid])
    @page = { requester: req, reviews: req.reviews.order(created_at: :desc), aggregates: req.aggregates }
  end
end