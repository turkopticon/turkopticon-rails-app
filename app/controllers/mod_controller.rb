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

  def load_person
    @person = Person.find(session[:person_id])
  end

  def index
    @title = "Reviews with no flags"
    @reports = Report.paginate(:page => params[:page],
                               :order => "id DESC",
                               :conditions => "requester_id is not null and ignores = 0 and is_flagged is null")
  end

  def flagged
    @title = "Reviews with new flags"
    @reports = Report.paginate(:page => params[:page],
                               :order => "id DESC",
                               :conditions => "is_flagged = 1 and ignores = 0")
    render :action => "index"
  end

  def ignored
    @title = "Reviews with ignored flags"
    @reports = Report.paginate(:page => params[:page],
                               :order => "id DESC",
                               :conditions => "is_flagged = 1 and ignores > 0")
    render :action => "index"
  end

  def multi_ignored
    @title = "Reviews with ignored flags"
    @reports = Report.paginate(:page => params[:page],
                               :order => "id DESC",
                               :conditions => "is_flagged = 1 and ignores > 1")
    render :action => "index"
  end

  def hidden
    @title = "Hidden reviews"
    @reports = Report.paginate(:page => params[:page],
                               :order => "id DESC",
                               :conditions => "is_flagged = 1 and is_hidden = 1")
    render :action => "index"
  end

end
