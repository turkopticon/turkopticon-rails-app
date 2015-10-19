class ForumController < ApplicationController

  before_filter :authorize, :load_person
  before_filter :authorize_as_admin, :only => [:admin]

  layout "forum"

  def load_person
    @person = Person.find(session[:person_id])
  end

  def index
    # get all posts with null parent ID
    @posts = ForumPost.find_all_by_parent_id_and_deleted(nil, nil)
  end

  def new_post
    # make new post and post_version objects
    # if request is post, check for errors, save new objects if OK
    @post = ForumPost.new(params[:forum_post])
    @post_version = ForumPostVersion.new(params[:forum_post_version])
    if request.post?
      if params[:forum_post_version][:body].blank?
        flash[:notice] = "<style type='text/css'>#notice { background-color: #f00; }</style>Please put something in the post body."
        render :action => "new_post" and return
      end
      if params[:forum_post][:parent_id].nil? and params[:forum_post_version][:title].blank?
        flash[:notice] = "<style type='text/css'>#notice { background-color: #f00; }</style>Please give the post a title."
        render :action => "new_post" and return
      end
      if @post.save and @post_version.save and @post_version.update_attributes(:post_id => @post.id)
        if @post.parent_id
          ForumPost.find(@post.thread_head).update_replies
        else
          @post.update_attributes(:thread_head => @post.id)
        end
        flash[:notice] = "Post saved."
        rid = @post.parent_id.nil? ? @post.id : @post.thread_head
        redirect_to "/forum/show_post/#{rid}\#post-#{@post.id}"
      end
    end
  end

  def show_post
    post = ForumPost.find(params[:id])
    if post.parent_id.nil?
      # user requested a thread head
      post.increment_views
      @posts = post.reply_posts
    else
      # user is requesting a post in the middle of a thread
      # redirect to thread head with anchor
      redirect_to "/forum/show_post/#{post.thread_head}\#post-#{params[:id]}"
    end
  end

  def post_versions
    @post = ForumPost.find(params[:id])
    @versions = @post.versions.reverse
  end

  def edit_post
    @post = ForumPost.find(params[:id])
    @current_version = @post.current_version
    @post_version = ForumPostVersion.new(params[:forum_post_version])
    if request.post?
      if params[:forum_post_version][:body].blank?
        flash[:notice] = "<style type='text/css'>#notice { background-color: #f00; }</style>Please put something in the post body."
        render :action => "edit_post" and return
      end
      if @post.nil? and params[:forum_post_version][:title].blank?
        flash[:notice] = "<style type='text/css'>#notice { background-color: #f00; }</style>Please give the post a title."
        render :action => "edit_post" and return
      end
      if @post.save and @post_version.save and @post_version.update_attributes(:post_id => @post.id) and @current_version.update_attributes(:next => @post_version.id)
        flash[:notice] = "Post saved."
        redirect_to :action => "show_post", :id => @post.id
      end
    end
  end

  def delete_post
    @post = ForumPost.find(params[:id])
    @post_version = ForumPostVersion.new(:person_id => session[:person_id],
                         :post_id => @post.id,
                         :body => "This post was deleted.",
                         :ip => request.remote_ip)
    @post_version.save
    @post.current_version.update_attributes(:next => @post_version.id)
    @post.update_attributes(:deleted => true)
    flash[:notice] = "The post was deleted."
    if @post.parent_id.nil?
      redirect_to :action => "index"
    else
      redirect_to :action => "show_post", :id => @post.parent_id
    end
  end

  def thank
    person_id = session[:person_id]
    person_info = ForumPersonInfo.find_by_person_id(person_id)
    effect = person_info.up_effect
    ReputationStatement.new(:person_id => person_id,
                            :post_id => params[:id],
                            :statement => "thanks",
                            :effect => effect).save
    redirect_to :action => "show_post", :id => params[:id]
  end

  def inappropriate
    person_id = session[:person_id]
    person_info = ForumPersonInfo.find_by_person_id(person_id)
    effect = person_info.down_effect
    ReputationStatement.new(:person_id => person_id,
                            :post_id => params[:id],
                            :statement => "inappropriate",
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

  def authorize_as_admin
    pid = session[:person_id]
    unless !pid.nil? and Person.find(pid) and Person.find(pid).is_admin
      session[:original_uri] = request.request_uri
      flash[:notice] = "Please log in as an administrator."
      redirect_to :controller => "reg", :action => "login"
    end
  end

  def admin
    reports = Report.all(:conditions => ["created_at > ?", Time.now - 1.month])
    @users = reports.map{|r| r.person}.uniq.sort_by{|p| p.reports.count}.reverse
  end

end
