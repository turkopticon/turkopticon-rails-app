class MainController < ApplicationController

  before_filter :authorize, :except => [:requester_stats, :info, :help, :help_v2, :install_v2, :install_welcome, :requester_attrs, :requester_attrs_v2, :ditz, :blog, :post, :blogfeed, :requesters, :requester_attrs_2, :x, :ferret_index, :rules, :dedupe_reqs, :backup_db, :check_for_duplicate_requester_objects, :wth]
  before_filter :check_for_existing_report, :only => :add_report
  before_filter :verify, :only => :add_report
  before_filter :authorize_as_commenter, :only => [:add_comment, :add_flag]

  def pri
  end

  def request_commenting
    Person.find(session[:person_id]).update_attributes(:commenting_requested => true, :commenting_requested_at => Time.now)
    flash[:notice] = "You've requested commenting."
    redirect_to :action => "index"
  end

  def check_for_existing_report
    if session[:person_id] and Person.find(session[:person_id]) and params[:requester]
      @requester = Requester.find_by_amzn_requester_id(params[:requester][:amzn_id])
      unless @requester.nil?
        @report = Report.find_by_person_id_and_requester_id(session[:person_id], @requester.id)
        unless @report.nil? or session[:person_id] == 1
          flash[:notice] = "<div class=\"success\">You have a review for that requester already. You can update it if you would like.</div>"
          redirect_to :action => "edit_report", :id => @report.id
        end
      end
    end
  end

  def index
    @pagetitle = "reports"
    @location = "reports" #if params[:id].nil? # commented this out to get the order option link (see ll. 45-46 below and ./_tabs.haml)
    if params[:id].nil?
      cond = "requester_id is not null and is_hidden is not true"
    elsif !Requester.find_by_amzn_requester_id(params[:id]).nil?
      cond = {:amzn_requester_id => params[:id]}
      if params[:hidden]
        cond[:is_hidden] = true
      else
        cond[:is_hidden] = nil
      end
    elsif !Requester.find(params[:id]).nil?
      cond = {:requester_id => params[:id]}
    end
    default_order = Person.find(session[:person_id]).order_reviews_by_edit_date ? "updated_at DESC" : "id DESC"
    @reports = Report.paginate :page => params[:page], :order => default_order, :conditions => cond
  end

  def averages
    @pagetitle = "stats"
    if params[:id].nil?
      render :text => "Which requester were you looking for stats for? Try turkopticon.info/aves/[AMT requester ID]."
    else
      @requesters = [Requester.find_by_amzn_requester_id(params[:id])]
    end
  end

  def report
    @pagetitle = "report"
    @reports = Report.find(params[:id])
    render :action => "index"
  end

  def reports_by
    @person = Person.find(params[:id])
    @display_name = Person.find(session[:person_id]).is_moderator ? @person.mod_display_name : @person.public_email
    @pagetitle = "reports by " + @display_name
    default_order = Person.find(session[:person_id]).order_reviews_by_edit_date ? "updated_at DESC" : "id DESC"
    @reports = Report.paginate :page => params[:page], :order => params[:order] ||= default_order, :conditions => {:person_id => params[:id]}
    @location = "reports by"
    render :action => "index"
  end

  def reports_by_ip
    @reports = Report.find_all_by_ip(params[:ip])
    render :action => "flagged_by"
  end

  def flagged_by
    @person = Person.find(params[:id])
    @display_name = Person.find(session[:person_id]).is_moderator ? @person.mod_display_name : @person.public_email
    @pagetitle = "reports flagged by " + @display_name
    @reports = @person.flags.map{|f| f.report}
  end

  def comments_by
    @person = Person.find(params[:id])
    @display_name = Person.find(session[:person_id]).is_moderator ? @person.mod_display_name : @person.public_email
    @pagetitle = "reports commented on by " + @display_name
    @reports = @person.comments.map{|f| f.report}
    render :action => "flagged_by"
  end

  def all_by
    @person = Person.find(params[:id])
    @display_name = Person.find(session[:person_id]).is_moderator ? @person.mod_display_name : @person.public_email
    @pagetitle = "reports flagged or commented on by " + @display_name
    @reports = @person.flags.map{|f| f.report} + @person.comments.map{|f| f.report}
    render :action => "flagged_by"
  end  

  def my_flagged
    @pagetitle = "reviews flagged by you"
    @location = "my_flagged"
    @reports = Person.find(session[:person_id]).flags.collect{|f| f.report}.compact.uniq.paginate :page => params[:page]
    @no_flags = true if @reports.empty?
    render :action => "index"
  end

  def flagged
    @pagetitle = "flagged reviews"
    @location = "flagged"
    @reports = Report.paginate(:page => params[:page], :conditions => {:is_flagged => true, :is_hidden => nil}, :order => "id DESC")
    @no_flags = true if @reports.empty?
    render :action => "index"
  end

  def hidden
    @pagetitle = "hidden reviews"
    @location = "hidden"
    @reports = Report.paginate(:page => params[:page], :conditions => {:is_hidden => true}, :order => "id DESC")
    render :action => "index"
  end

  def my_reviews
    @pagetitle = "your reviews"
    @location = "my_reviews"
    if Person.find(session[:person_id]).most_recent_first_in_my_reviews
      @reports = Report.paginate :page => params[:page], :conditions => {:person_id => session[:person_id]}, :order => "id DESC"
    else
      @reports = Report.paginate :page => params[:page], :conditions => {:person_id => session[:person_id]}
    end
    @no_reviews = true if @reports.empty?
    render :action => "index"
  end

  def php_search
    @result = `php #{RAILS_ROOT}/php_api/search.php "#{params[:query]}"`
    parsed_result = JSON[@result]
    @reports = parsed_result["reviews"]
    @render_time = parsed_result["render_time"] ||= 0.0
    @query_time = parsed_result["query_time"] ||= 0.0
    @result_count = parsed_result["results_count"]
    @requester_count = @reports.map{|r| r["amzn_requester_id"]}.uniq.count
  end

  def php_search_form
  end

  def search_mysql # good, but do not use, very slow; will choke site
    requesters = Requester.find(:all, :conditions => ["amzn_requester_name like ?", "%#{params[:query]}%"])
    @reports = requesters.collect{|r| r.reports}.flatten
    total_rep_count = @reports.length
    @reports.delete_if{|r| r.is_hidden}
    @hidden_rep_count = total_rep_count - @reports.length
  end

  def search
    @reports = Report.find_with_ferret(params[:query])
    Requester.find_with_ferret(params[:query]).each{|r| r.reports.each{|rep| @reports << rep}}
    total_rep_count = @reports.length
    @reports.delete_if{|r| r.is_hidden}
    @reports = @reports.sort_by{|r| r.created_at}.reverse
    @hidden_rep_count = total_rep_count - @reports.length

    # log search queries to separate log file
    # for search redesign
    log_str = "[" + Time.now.strftime("%Y-%m-%d %H:%M:%S") + "] "
    log_str += "[" + request.remote_ip + "] "
    log_str += params[:query] + "\n"
    File.open("#{RAILS_ROOT}/log/search.log", 'a') {|f| f.write(log_str)}
  end

  def search_all
    @reports = Report.find_with_ferret(params[:query])
    Requester.find_with_ferret(params[:query]).each{|r| r.reports.each{|rep| @reports << rep}}
  end

  def requesters
    @pagetitle = "requesters"
    @location = "requesters"
    order = params[:order] ||= "updated_at DESC"
    safe_order_values = ["updated_at DESC", "updated_at ASC", "amzn_requester_name DESC", "amzn_requester_name ASC", "nrs ASC", "nrs DESC", "ava ASC", "ava DESC"]
    if safe_order_values.include?(order)
      cond = ["updated_at > ?", Time.now - 5.days]
      page = params[:page]
      @requesters = Requester.paginate(:conditions => cond, :page => page, :order => order)
    else
      render :text => "Sorry, something broke."
    end
  end

  def all_requesters
    @pagetitle = "requesters"
    @location = "requesters"
    @requesters = Requester.paginate :page => params[:page], :order => params[:order] ||= "amzn_requester_name ASC"
    respond_to do |format|
      format.html  # requesters.haml
      format.csv {
        content = Requester.report_table(:all,
					:only => ['amzn_requester_id', 'amzn_requester_name'],
					:methods => [:comm, :pay, :fair, :fast, :report_count, :reporter_count]).as(:csv)
        send_data(content, :filename => 'turkopticon_report_' + Time.now.strftime("%Y%m%d_%H%M") + ".csv", :type => "application/csv")
      }
    end
  end

  def add_report
    @pagetitle = "add report"
    @report = Report.new(params[:report])
    if request.post?
      if params[:requester][:amzn_id].blank?
        flash[:notice] = "<div class=\"error\">Please fill in the requester ID.</div>"
        render :action => "add_report" and return
      end
      unless params[:requester][:amzn_id] =~ /\AA[0-9A-Z]{9,}\z/
        flash[:notice] = "<div class=\"error\">Please enter a Mechanical Turk requester ID in the requester ID field.</div>"
        render :action => "add_report" and return
      end
      if params[:requester][:amzn_name].blank? or params[:requester][:amzn_name] == "null"
        flash[:notice] = "<div class=\"error\">Please fill in the requester name.</div>"
        render :action => "add_report" and return
      end
      if params[:requester][:amzn_name] == "undefined"
        flash[:notice] = "<div class=\"error\">Please fill in the requester name and update your version of Turkopticon.</div>"
        render :action => "add_report" and return
      end
      if params[:requester][:amzn_name] != ActionView::Base.full_sanitizer.sanitize(params[:requester][:amzn_name])
        flash[:notice] = "<div class=\"error\">Please remove the HTML from the requester name and update your version of Turkopticon.</div>"
        render :action => "add_report" and return
      end
      if params[:report][:description].blank?
        flash[:notice] = "<div class=\"error\">Please fill in the report description.</div>"
        render :action => "add_report" and return
      end
      if @report.save
        @report.update_attributes(:amzn_requester_name => params[:requester][:amzn_name])
        r = Requester.find_by_amzn_requester_id(params[:requester][:amzn_id])
        if !r.nil? and r.amzn_requester_name == "null"
          r.update_attributes(:amzn_requester_name => params[:requester][:amzn_name])
        end
        if r.nil?
          Requester.new(:amzn_requester_id => params[:requester][:amzn_id], :amzn_requester_name => params[:requester][:amzn_name]).save
          r = Requester.find_by_amzn_requester_id(params[:requester][:amzn_id])
        end
        if @report.update_attributes(:requester_id => r.id, :amzn_requester_id => r.amzn_requester_id)

          t = Time.now.strftime("%H:%M %a %b %d %Y")
          ip = request.remote_ip
          IPLogger.info "[#{t}] #{@report.person.email} posted report #{@report.id.to_s} from #{ip}:"
          IPLogger.info " ---- " + @report.print_h

          %w{comm pay fair fast}.each{|a| eval("@report.update_attributes(:" + a + " => 0) if @report." + a + ".nil?")}
          r.cache_columns
          flash[:notice] = "<div class=\"success\">Report successfully saved.</div>"
          rurl = params[:url][:url].blank? ? "https://www.mturk.com/mturk/findhits?match=false" : params[:url][:url]
          redirect_to rurl + "&updated=" + params[:requester][:amzn_id]
        end
      end
    end
  end

  def add_flag
    @report = Report.find(params[:id])
    @flag = Flag.new(params[:flag])
    if request.post?
      if params[:flag][:comment].blank?
        flash[:notice] = "<div class=\"error\">Please add a comment.</div>"
        render :action => "add_flag", :id => @report.id and return
      end
      pfc = params[:flag][:comment]
      pfce = params[:other_explanation]
      l = pfce.length if pfce
      default_pfce = "explanation for 'other', min. 20 chars, max. 140"
      if pfc == "other"
        if pfce == default_pfce or (!l.nil? and (l < 20 or l > 140))
          render :text => "Sorry, you must enter an explanation for your flag not shorter than 20 characters and not longer than 140 characters. Please use your browser's 'back' button to go back." and return
        else
          params[:flag][:comment] = pfc + ": " + pfce
        end
      end
      if @flag.save and @report.update_flag_data
        @report.update_attributes(:flag_count => @report.flags.count)
        flash[:notice] = "<div class=\"success\">Report was flagged.</div>"
        FlagMailer::deliver_notify(@report.id, @flag.comment)
        redirect_to :controller => "main", :action => "index", :id => @report.requester_amzn_id
      end
    end
  end

  def flag
    @report = Report.find(params[:id])
    @flag = Flag.new
  end

  def cancel_flag
    @id = params[:id]
  end

  # this one is deprecated in favor of convert_flag below
  def unflag
    @flag = Flag.find(params[:id])
    @requester = @flag.report.requester
    @report = @flag.report
    @flag.destroy
    @report.update_flag_data
    flash[:notice] = "Your flag was removed from the review."
    redirect_to :action => "index", :id => @requester.amzn_requester_id
  end

  def convert_flag
    @flag = Flag.find(params[:id])
    @requester = @flag.report.requester
    @report = @flag.report
    @flag.convert_to_comment
    @report.update_attributes(:flag_count => @report.flags.count, :comment_count => @report.comments.count)
    # @report.update_flag_data  # this is handled by Flag::convert_to_comment
    redirect_to :action => "index", :id => @requester.amzn_requester_id
  end

  def add_comment
    @report = Report.find(params[:id])
    @comment = Comment.new(params[:comment])
    if request.post?
      if params[:comment][:body].blank?
        flash[:notice] = "<div class=\"error\">Please add a comment.</div>"
        render :action => "add_comment", :id => @report.id and return
      end
      if @comment.save
        @report.update_attributes(:comment_count => @report.comments.count)
        flash[:notice] = "<div class=\"success\">Comment added.</div>"
        redirect_to :controller => "main", :action => "index", :id => @report.requester_amzn_id
      end
    end
  end

  def report
    @report = Report.find(params[:id])
  end

  def edit_report
    @pagetitle = "edit report"
    @report = Report.find(params[:id])
    if session[:person_id] == @report.person_id or Person.find(session[:person_id]).is_admin
      @requester = Requester.find(@report.requester_id)
      if request.post? and @report.update_attributes(params[:report])
        editor = ""
        if session[:person_id] == @report.person_id
          editor = "the author "
        else  # assume admin
          editor = "<strong>" + Person.find(session[:person_id]).display_name + "(admin) </strong> "
        end
        note = "This review was edited by " + editor + Time.now.strftime("%a %b %d %H:%M %Z") + ".<br/>"
        @report.update_attributes(:displayed_notes => note + @report.displayed_notes.to_s)
        @requester.cache_columns
        flash[:notice] = "<div class=\"success\">Report updated.</div>"
        redirect_to :action => "index"
      end
    else
      flash[:notice] = "<div class=\"error\">You can't edit that review.</div>"
      redirect_to :action => "index"
    end
  end

  def edit_comment
    @pagetitle = "edit comment"
    @comment = Comment.find(params[:id])
    if session[:person_id] == @comment.person_id or Person.find(session[:person_id]).is_admin
      @report = @comment.report
      if request.post? and @comment.update_attributes(params[:comment])
        if session[:person_id] == @comment.person_id
          editor = "the author "
        else
          editor = "<strong>" + Person.find(session[:person_id]).display_name + " (admin)</strong> "
        end
        note = "This comment was edited by " + editor + Time.now.strftime("%a %b %d %H:%M %Z") + ".<br/>"
        @comment.update_attributes(:displayed_notes => note + @comment.displayed_notes.to_s)
        flash[:notice] = "<div class=\"success\">Comment updated.</div>"
        redirect_to :action => "report", :id => @comment.report_id.to_s
      end
    else
      flash[:notice] = "<div class=\"error\">You can't edit that comment.</div>"
      redirect_to :action => "index"
    end
  end

  def edit_flag
    render :text => "That function is disabled."
  end

  def edit_flag_disabled
  # def edit_flag
    @pagetitle = "edit flag"
    @flag = Flag.find(params[:id])
    if session[:person_id] == @flag.person_id or Person.find(session[:person_id]).is_admin
      @report = @flag.report
      if request.post? and @flag.update_attributes(params[:flag])
        if session[:person_id] == @flag.person_id
          editor = "the author "
        else
          editor = "<strong>" + Person.find(session[:person_id]).display_name + " (admin)</strong> "
        end
        note = "This flag was edited by " + editor + Time.now.strftime("%a %b %d %H:%M %Z") + ".<br/>"
        @flag.update_attributes(:displayed_notes => note + @flag.displayed_notes.to_s)
        flash[:notice] = "<div class=\"success\">Flag updated.</div>"
        redirect_to :action => "report", :id => @flag.report_id.to_s
      end
    else
      flash[:notice] = "<div class=\"error\">You can't edit that flag.</div>"
      redirect_to :action => "index"
    end
  end

  def requester_stats
    @requester = Requester.find_by_amzn_requester_id(params[:id])
    if @requester.nil?
      render :text => "null"
    else
      render :text => "reports:" + @requester.report_count.to_s + ",users:" + @requester.reporter_count.to_s
    end
  end

  def requester_attrs
    @requester = Requester.find_by_amzn_requester_id(params[:id])
    if @requester.nil?
      render :text => "null"
    else
      render :text => @requester.attrs_text
    end
  end

  def requester_attrs_2
    @requester = Requester.find_by_amzn_requester_id(params[:id])
    if @requester.nil?
      render :text => "null"
    else
      render :text => @requester.attrs_text_2
    end
  end
  
  def requester_attrs_v2
    @requester = Requester.find_by_amzn_requester_id(params[:id])
    if @requester.nil?
      render :text => "null"
    else
      render :text => @requester.attrs_text_v2
    end
  end

  def info
    @location = "about"
  end

  def info2
    @location = "about"
  end

  def install_welcome
    @location = "install_welcome"
  end

  def install_v2
    @pagetitle = "install_v2"
    @location = "install_v2"
  end

  def help
    @pagetitle = "help"
    @location = "help"
  end
  
  def help_v2
  end

  def ditz
    redirect_to "http://turkopticon.differenceengines.com/ditz/index.html"
  end

  def blog
    @location = "blog"
    @posts = Post.find(:all, :order => "created_at DESC", :conditions => "parent_id is null")
  end

  def blogfeed
    @posts = Post.find(:all, :order => "created_at DESC", :conditions => "parent_id is null")
    respond_to do |format|
      format.rss {render}
    end
  end

  def post
    @post = Post.find_by_slug(params[:id])
    if @post.nil?
      @post = Post.find(params[:id])
      if @post.nil?
        flash[:notice] = "<div class='error'>Sorry, couldn't find that post.</div>"
        redirect_to :action => "blog"
      end
    end
  end

  def add_post
    @post = Post.new(params[:post])
    if request.post? and @post.save
      @post.update_attributes(:slug => @post.title.downcase.gsub(/ /,"_"))
      # insert slug uniqueness checking here if this becomes an issue
      flash[:notice] = "<div class='success'>Post \"#{@post.title}\" saved.</div>"
      if @post.parent_id.nil?
        redirect_to :action => "blog"
      else
        redirect_to :action => "post", :id => @post.parent.id
      end
    end
  end

  def edit_post
    @post = Post.find(params[:id])
    if request.post? and @post.update_attributes(params[:post])
      flash[:notice] = "<div class='success'>Post updated.</div>"
      redirect_to :action => "post", :id => @post.id
    end
  end

  def x
  end

  def rules
    @location = "rules"
  end

  def wth
  end

  def ferret_index
    # call with, e.g.,
    # wget -c http://turkopticon.differenceengines.com/main/ferret_index > /dev/null 2>&1
    system "/usr/bin/rake ferret_index"
    render :text => "Successfully rebuilt Ferret indices"
  end

  def dedupe_reqs
    render :text => "Did nothing, this is currently deactivated"
  end

  def dedupe_reqs_old
    # don't use this
    ids = {}
    Requester.all.each{|r|
    id = r.amzn_requester_id
    unless id.nil? or r.amzn_requester_name.blank?
      ids[id].nil? ? ids[id] = [r.id] : ids[id] << r.id
    end
    }
    mult = ids.select{|k, v| v.length > 1}
    mult.each{|r|
    ii = r.last
    cid = ii.shift
      ii.each{|i|
        Requester.find(i).reports.each{|r|
        r.update_attributes(:requester_id => cid)
        }
      Requester.find(i).destroy
      }
    Requester.find(cid).cache_columns
    }
    render :text => "Successfully deduplicated #{mult.length} Requester objects"
  end

  def backup_db
    system "mysqldump -ce -u rahrahfe_bentham -pn0mn0m=== rahrahfe_turkopticon > /home1/rahrahfe/turkopticon-passenger/backups/turkopticon-db-`date +%Y.%m.%d.%H%M`.sql"
    render :text => "Backed up database."
  end

  def check_for_duplicate_requester_objects
    ids = Requester.all.map{|r| r.amzn_requester_id}.delete_if{|i| i.blank?} 
    hash = ids.group_by{|i| i} 
    duplicate_ids = hash.select{|k, v| v.size > 1}.map(&:first)
    if duplicate_ids.empty?
      render :text => ""
    else
      render :text => "Duplicate Requester objects exist for requesters with IDs " + duplicate_ids.join(", ")
    end
  end

end
