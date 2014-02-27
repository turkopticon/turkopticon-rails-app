class AdminController < ApplicationController

  before_filter :authorize, :authorize_as_admin
  layout nil

  def authorize_as_admin
    pid = session[:person_id]
    unless !pid.nil? and Person.find(pid) and Person.find(pid).is_admin
      session[:original_uri] = request.request_uri
      flash[:notice] = "Please log in as an administrator."
      redirect_to :controller => "reg", :action => "login"
    end
  end

  def index
  end

  def dashboard
    @user_count = Person.count
    @new_user_count = Person.all(:conditions => ["created_at > ?", Time.now - 1.month]).count
    @active_user_count = Report.all(:conditions => ["created_at > ?", Time.now - 1.month]).collect{|r| r.person_id}.uniq.count
    # @active_user_count = Report.all.select{|r| r.created_at > Time.now - 1.month}.collect{|r| r.person_id}.uniq.count  # slow, don't do that
    @report_count = Report.count
    @requester_count = Requester.count
    @recent_reports = Report.all(:conditions => ["created_at > ?", Time.now - 1.month])
    @recent_report_count = @recent_reports.count
    authors = @recent_reports.map{|r| {"id" => r.person_id, "name" => r.person.display_name.nil? ? r.person.email : r.person.display_name}}
    @authors_with_counts = authors.group_by{|a| [a["id"], a["name"]]}.map{|k, v| [k, v.length]}.sort_by{|a| a[1]}.reverse
    @recent_flags = Flag.all(:conditions => ["created_at > ?", Time.now - 1.month])
    # @recent_flags = Flag.all.select{|f| f.created_at > Time.now - 1.month}  # slow
    @recently_flagged_reports = @recent_flags.collect{|f| f.report_id}
    @recent_flaggers = @recent_flags.collect{|f| f.person_id}
    top_flaggers = {}
    @recent_flaggers.each do |pid|
      if top_flaggers[pid].nil?
        top_flaggers[pid] = 1
      else
        top_flaggers[pid] += 1
      end
    end
    @ordered_flaggers = top_flaggers.sort_by{|k, v| v}.reverse
  end

  def duplicated_requesters
    ids = Requester.all.map{|r| r.amzn_requester_id}.delete_if{|i| i.blank?}
    hash = ids.group_by{|i| i}  # slow
    duplicates = hash.select{|k, v| v.size > 1}.map(&:first)
    render :text => duplicates.join(", ")
  end

end
