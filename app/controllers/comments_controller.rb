class CommentsController < ApplicationController

  def create
    @comment        = Comment.new(comment_params)
    @comment.person = @user
    @comment.review = Review.unscoped.find(params[:r])
    @comment.body.strip!
    if @comment.save
      # OMNILOGGER.comment ltag("CREATE comment for review##{params[:r]}")
      flash[:success] = 'Your comment was saved'
    else
      flash[:notice] = 'Your comment was unable to be saved'
    end

    redirect_back fallback_location: proc { requesters_path(params[:r]) }
  end

  private

  def comment_params
    params.permit(:body)
  end
end