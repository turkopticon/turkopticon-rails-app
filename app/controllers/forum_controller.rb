class ForumController < ApplicationController

  before_filter :authorize, :load_person

  layout "forum"

  def load_person
    @person = Person.find(session[:person_id])
  end

  def index
    # get all posts with null parent ID
    @posts = ForumPost.find_all_by_parent_id(nil)
  end

  def new_post
    # make new post and post_version objects
    # if request is post, check for errors, save new objects if OK
    @post = ForumPost.new(params[:forum_post])
    @post_version = ForumPostVersion.new(params[:forum_post_version])
    if request.post?
      if params[:forum_post_version][:body].blank?
        flash[:notice] = "<div class='error'>Please put something in the post body.</div>"
        render :action => "new_post" and return
      end
      if params[:forum_post][:parent_id].nil? and params[:forum_post_version][:title].blank?
        flash[:notice] = "<div class='error'>Please give the post a title.</div>"
        render :action => "new_post" and return
      end
      if @post.save and @post_version.save and @post_version.update_attributes(:post_id => @post.id)
        flash[:notice] = "Post saved."
        redirect_to :action => "show_post", :id => @post.id
      end
    end
  end

  def show_post
    @post = ForumPost.find(params[:id])
    @post.increment_views
  end

  def edit_post
    @post = ForumPost.find(params[:id])
    @current_version = @post.current_version
    @post_version = ForumPostVersion.new(params[:forum_post_version])
    if request.post?
      if params[:forum_post_version][:body].blank?
        flash[:notice] = "<div class='error'>Please put something in the post body.</div>"
        render :action => "edit_post" and return
      end
      if params[:forum_post][:parent_id].nil? and params[:forum_post_version][:title].blank?
        flash[:notice] = "<div class='error'>Please give the post a title.</div>"
        render :action => "edit_post" and return
      end
      if @forum_post.save and @forum_post_version.save
        flash[:notice] = "Post saved."
        redirect_to :action => "show_post", :id => @post.id
      end
    end
  end

  def delete_post
    ForumPostVersion.find(params[:id]).delete
  end

  def thank
    person_id = session[:person_id]
    person_info = ForumPersonInfo.find_by_person_id(person_id)
    effect = person_info.up_effect
    ReputationStatement.new(:person_id => session[:person_id],
                            :post_id => params[:id],
                            :statement => "thanks",
                            :effect => effect).save
    redirect_to :action => "show_post", :id => params[:id]
  end

  def downvote
    person_id = session[:person_id]
    person_info = ForumPersonInfo.find_by_person_id(person_id)
    effect = person_info.down_effect
    ReputationStatement.new(:person_id => person_id,
                            :post_id => params[:id],
                            :statement => "down",
                            :effect => effect).save
    redirect_to :action => "show_post", :id => params[:id]
  end

  def posts_by
    @live_posts = []
    posts = Forum.find_all_by_person_id(params[:id])
    posts.each{|p| @live_posts << [p, p.current_version]}
  end

  def settings
  end

end
