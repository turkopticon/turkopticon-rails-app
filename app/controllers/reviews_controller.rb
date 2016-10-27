class ReviewsController < ApplicationController

  def index
    query = params.extract!(:user, :comments, :flags)
    @page = { location: query.values.reject { |v| v == 'false' }.length > 0 ? 'Reviews' : 'Recent Reviews',
              rname:    params[:rid] && "for #{params[:rid]}",
              params:   query.to_unsafe_h }
  end

end