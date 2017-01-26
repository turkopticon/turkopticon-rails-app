class FlagsController < ApplicationController
  def create
    @flag        = Flag.new flag_params
    @flag.person = @user
    @flag.review = Review.unscoped.find(params[:r])
    if @flag.save
      flash[:success] = 'Flag added'
    else
      flash[:error] = 'Your flag was unable to be saved'
    end

    redirect_back fallback_location: proc { requesters_path(params[:r]) }
  end

  private

  def flag_params
    params.permit(:reason)
  end
end