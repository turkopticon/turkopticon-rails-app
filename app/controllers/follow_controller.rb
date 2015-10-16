class FollowController < ApplicationController

  def follow_post
    Follow.new(:person_id => session[:person_id], :follow_type => "post", :follow_id => params[:id]).save
    redirect_to :action => "show_post", :id => params[:id]
  end

  def unfollow_post
    Follow.find(:person_id => session[:person_id], :follow_type => "post", :follow_id => params[:id]).destroy
    redirect_to :action => "show_post", :id => params[:id]
  end

  def follow_person
    Follow.new(:person_id => session[:person_id], :follow_type => "person", :follow_id => params[:id]).save
    redirect_to :action => "show_post", :id => params[:post_id]
  end

  def unfollow_person
    Follow.find(:person_id => session[:person_id], :follow_type => "person", :follow_id => params[:id]).destroy
    redirect_to :action => "show_post", :id => params[:post_id]
  end

end