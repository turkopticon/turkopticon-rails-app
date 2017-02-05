class RequestersController < ApplicationController
  before_action -> { require_access_level :verified }

  def index
    @page              = { title: params[:q] ? "Search results for '#{params[:q]}'" : 'Recently reviewed requesters' }
    @page[:requesters] = if params[:q].present?
                           Requester.name_search(params[:q]).page(params[:page])
                         else
                           Requester.page(params[:page])
                         end
  end

  def show
    req                = Requester.cached_find_by(rid: params[:rid])
    @page              = { requester: req }
    @page[:reviews]    = req.reviews.newest.valid.page(params[:page])
    @page[:aggregates] = req.cached_aggregates
  end
end