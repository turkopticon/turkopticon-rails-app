class ModController < ApplicationController

  before_filter :authorize, :authorize_as_moderator, :load_person
  layout "moderator"

  def authorize_as_moderator
    pid = session[:person_id]
    unless !pid.nil?
      @person = Person.find(pid)
      unless !@person.nil? and @person.is_moderator
        session[:original_uri] = request.request_uri
        flash[:notice] = "Please log in as a moderator."
        redirect_to :controller => "reg", :action => "login"
      end
    end
  end

  def edit_rules
    @rv = RulesVersion.new(params[:rules_version])
    if request.post?
      @rv.edited_by_person_id = session[:person_id]
      @rv.save
      old = RulesVersion.current
      old.update_attributes(:is_current => nil)
      new_body = @rv.body.gsub("\n", "<br/>")
      @rv.update_attributes(:parent_id => old.id, :body => new_body, :is_current => true)
      render :text => "Instructions updated."
    end
  end

  def load_person
    @person = Person.find(session[:person_id])
  end

  def index
    @title = "Reviews with no flags"
    @reports = Report.paginate(:page => params[:page],
                               :order => "id DESC",
                               :conditions => "requester_id is not null and ignore_count = 0 and is_flagged is null")
  end

  def flagged
    @title = "Reviews with new flags"
    @reports = Report.paginate(:page => params[:page],
                               :order => "id DESC",
                               :conditions => "is_flagged = 1 and ignore_count = 0 and is_hidden is null")
    render :action => "index"
  end

  def ignored
    @title = "Reviews with ignored flags"
    @reports = Report.paginate(:page => params[:page],
                               :order => "id DESC",
                               :conditions => "is_flagged = 1 and ignore_count > 0")
    render :action => "index"
  end

  def multi_ignored
    @title = "Reviews with ignored flags"
    @reports = Report.paginate(:page => params[:page],
                               :order => "id DESC",
                               :conditions => "is_flagged = 1 and ignore_count > 1")
    render :action => "index"
  end

  def hidden
    @title = "Hidden reviews"
    @reports = Report.paginate(:page => params[:page],
                               :order => "id DESC",
                               :conditions => "is_flagged = 1 and is_hidden = 1")
    render :action => "index"
  end

  def flag
    @report = Report.find(params[:id])
    @flag = Flag.new(params[:flag])
    if request.post? and @flag.save and @report.update_flag_data
      @report.update_attributes(:flag_count => @report.flags.count)
      flash[:notice] = "Flagged report #{params[:id]}."
      redirect_to :action => "index"
    end
  end

  def agree_with_flagger
    Flag.create(:person_id => session[:person_id], :report_id => params[:id], :comment => "agree w/ flagger")
    report = Report.find(params[:id])
    report.update_flag_data
    report.update_attributes(:flag_count => report.flags.count)
    flash[:notice] = "Added new flag to report #{params[:id]} with text 'agree w/ flagger'."
    redirect_to :action => "flagged"
  end

  def ignore
    Ignore.create(:person_id => session[:person_id], :report_id => params[:id])
    report = Report.find(params[:id])
    report.update_attributes(:ignore_count => report.ignores.count)
    flash[:notice] = "Ignored flags on report #{params[:id]}."
    redirect_to :action => "flagged"
  end

  def comment
    @report = Report.find(params[:id])
    @comment = Comment.new(params[:comment])
    if request.post? and @comment.save
      @report.update_attributes(:comment_count => @report.comments.count)
      flash[:notice] = "Comment added to report #{params[:id]}."
      redirect_to :action => "flagged"
    end
  end

  def cancel_lightbox
    @id = params[:id]
  end

end
