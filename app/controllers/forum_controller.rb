class ForumController < ApplicationController

  before_filter :authorize, :load_person
  before_filter :authorize_as_admin, :only => [:karma]
  before_filter :authorize_as_commenter, :only => [:new_post, :edit_post, :delete_post, :thank, :inappropriate, :unthank, :uninappropriate]

  layout "forum"

  def load_person
    @person = Person.find(session[:person_id])
  end

  def index
    # get all posts with null parent ID
    @posts = ForumPost.find_all_by_parent_id_and_deleted(nil, nil).delete_if{|p| p.score <= -5.0 and p.has_inappro}.sort_by{|p| p.last_reply_at || p.updated_at}.reverse
  end

  def new_post
    # make new post and post_version objects
    # if request is post, check for errors, save new objects if OK
    @post = ForumPost.new(params[:forum_post])
    @post_version = ForumPostVersion.new(params[:forum_post_version])
    if request.post?
      unless @person.email_verified
        flash[:notice] = "<style type='text/css'>#notice { background-color: #f00; }</style>Sorry, you must verify your email address before you can post. You may <a href='/reg/send_verification_email'>send the verification email again</a>."
        render :action => "new_post" and return
      end
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

        # set initial post score to user's karma
        # create FPI object if it doesn't exist yet (and set karma to 1)
        fpi = ForumPersonInfo.find_by_person_id(session[:person_id])
        if fpi.nil?
          fpi = ForumPersonInfo.create(:person_id => session[:person_id])
        end
        if fpi.karma.nil?
          fpi.update_attributes(:karma => 1)
        end
        @post.update_attributes(:score => fpi.karma)

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

    # if this person has already thanked this post, tell them and send them back
    if ReputationStatement.find_by_person_id_and_post_id_and_statement(person_id, params[:id], "thanks")
      flash[:notice] = "<style type='text/css'>#notice { background-color: #f00; }</style>Sorry, you have already given thanks for this post!"
      redirect_to :action => "show_post", :id => params[:id] and return
    end

    # if this person has already thanked three times in the last 24 hours,
    # tell them they have to wait and send them back
    if ReputationStatement.all(:conditions => ["person_id = ? and statement = 'thanks' and created_at > ?", person_id, Time.now - 1.day]).count >= 3
      flash[:notice] = "<style type='text/css'>#notice { background-color: #f00; }</style>Sorry, you can only leave 3 \"thanks\" per day, and you have already left 3 in the last 24 hours. You can delete one or wait."
      redirect_to :action => "show_post", :id => params[:id] and return
    end

    person_info = ForumPersonInfo.find_by_person_id(person_id)
    if person_info.nil?
      person_info = ForumPersonInfo.create(:person_id => person_id)
    end
    effect = person_info.up_effect
    pid = ForumPost.find(params[:id]).person_id  # person who posted the post
                                                 # being rated

    # block self-thanking
    if pid == person_id
      flash[:notice] = "<style type='text/css'>#notice { background-color: #f00; }</style>Please don't try to thank yourself :-/"
      redirect_to :action => "show_post", :id => params[:id] and return
    end

    ReputationStatement.new(:person_id => person_id,
                            :post_id => params[:id],
                            :statement => "thanks",
                            :effect => effect,
                            :ip => request.remote_ip).save
    fpi = ForumPersonInfo.find_by_person_id(pid)
    if fpi.nil?
      fpi = ForumPersonInfo.create(:person_id => pid, :karma => 1)
    end
    current_karma = fpi.karma
    fpi.update_attributes(:karma => current_karma + 0.1 * effect)
    fp = ForumPost.find(params[:id])
    if fp.score.nil?
      new_score = effect
    else
      new_score = fp.score + effect
    end
    fp.update_attributes(:score => new_score)
    redirect_to :action => "show_post", :id => params[:id]
  end

  def inappropriate
    person_id = session[:person_id]

    # if the user flagging has already flagged this post, say so and send them back
    if ReputationStatement.find_by_person_id_and_post_id_and_statement(person_id, params[:id], "inappropriate")
      flash[:notice] = "<style type='text/css'>#notice { background-color: #f00; }</style>You've already flagged this post as inappropriate."
      redirect_to :action => "show_post", :id => params[:id] and return
    end

    # if this person has already left 1 'inappropriate' flag in the last 24 hours
    # tell them they have to wait and send them back
    if ReputationStatement.all(:conditions => ["person_id = ? and statement = 'inappropriate' and created_at > ?", person_id, Time.now - 1.day]).count >= 1
      flash[:notice] = "<style type='text/css'>#notice { background-color: #f00; }</style>Sorry, you can only leave 1 \"inappropriate\" flag per day, and you have already left one in the last 24 hours. You can delete it or wait."
      redirect_to :action => "show_post", :id => params[:id] and return
    end

    person_info = ForumPersonInfo.find_by_person_id(person_id)
    if person_info.nil?
      person_info = ForumPersonInfo.create(:person_id => person_id)
    end
    effect = person_info.down_effect
    pid = ForumPost.find(params[:id]).person_id  # person who posted the post
                                                 # being rated
    ReputationStatement.new(:person_id => person_id,
                            :post_id => params[:id],
                            :statement => "inappropriate",
                            :effect => effect,
                            :ip => request.remote_ip).save
    fpi = ForumPersonInfo.find_by_person_id(pid)
    if fpi.nil?
      fpi = ForumPersonInfo.create(:person_id => pid, :karma => 1)
    end
    current_karma = fpi.karma
    fpi.update_attributes(:karma => current_karma + 0.1 * effect)
    fp = ForumPost.find(params[:id])
    if fp.score.nil?
      new_score = effect
    else
      new_score = fp.score + effect
    end
    fp.update_attributes(:score => new_score)
    redirect_to :action => "show_post", :id => params[:id]
  end

  def unthank
    rs = ReputationStatement.find_by_person_id_and_post_id(session[:person_id],
                                                           params[:id])
    # update post score
    fp = ForumPost.find(params[:id])
    fp.update_attributes(:score => fp.score - rs.effect)
    # update posting user karma
    fpi = ForumPersonInfo.find_by_person_id(fp.person_id)
    fpi.update_attributes(:karma => fpi.karma - 0.1 * rs.effect)
    rs.destroy
    redirect_to :action => "show_post", :id => params[:id]
  end

  def uninappropriate
    # assume each user only has a "thank" OR an "inappropriate" on any post;
    # as a result we can use the same method for both
    redirect_to :action => "unthank", :id => params[:id]
  end

  def posts_by
    @posts = ForumPost.find_all_by_person_id(params[:id])
    render :action => "show_post"  # this is currently a confusing view; should be improved before making public
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

  def authorize_as_commenter
    pid = session[:person_id]
    unless !pid.nil? and Person.find(pid) and Person.find(pid).can_comment
      flash[:notice] = "<style type='text/css'>#notice { background-color: #f00; }</style>Sorry, only people with commenting ability can do that.</style>"
      redirect_to :action => "index"
    end
  end

  def about
  end

  def karma
  end

end
