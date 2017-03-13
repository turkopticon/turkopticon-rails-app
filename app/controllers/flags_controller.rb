class FlagsController < ApplicationController
  include AB::Core

  def create
    @flag        = Flag.new flag_params
    @flag.person = @user
    @flag.review = Review.unscoped.find(params[:r])
    if @flag.save
      ab_conversion(:ab_nflockup, session[:ab_nflockup], @user.id)
      flash[:success] = 'Your flag was added and will be reviewed by a moderator'
      Omnilogger.flag ltag("CREATE flag for review##{params[:r]}: #{@flag.reason}")
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