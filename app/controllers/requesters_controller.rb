class RequestersController < ApplicationController
  before_action -> { require_access_level :verified }

  def index
    @page              = { title: params[:q] ? "Search results for '#{params[:q]}'" : 'Recently reviewed requesters' }
    @page[:requesters] = if params[:q].present?
                           Requester.name_search(params[:q]).page(params[:page] || 1)
                         else
                           Requester.page(params[:page] || 1)
                         end
  end

  def show
    req                = Requester.cached_find_by(rid: params[:rid])
    @page              = { requester: req }
    @page[:reviews]    = req.reviews.newest.page(params[:page] || 1)
    @page[:aggregates] = req.cached_aggregates
  end
end