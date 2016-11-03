class ReviewsController < ApplicationController

  def index
    # TODO: fully integrate queries
    query = params.slice(:user, :comments, :flags)
    @page = { location: query.values.reject { |v| v == 'false' }.length > 0 ? 'Reviews' : 'Recent Reviews',
              rname:    params[:rid] && "for #{Requester.find_by(params[:rid]).rname || params[:rid]}",
              params:   query.to_unsafe_h,
              reviews:  query[:user] ? Review.by_user(query[:user]) : Review.newest(25) }

  end

end