class Mod::FlagsController < Mod::DashboardController
  def index
    @page          = { counts: Flag.counts }
    @page[:open]   = params[:s].nil? || params[:s] =~ /is:open/
    @page[:closed] = params[:s] && params[:s] =~ /is:closed/
    case params[:s]
      when /is:closed/
        @page[:title] = 'Closed Flags'
        @flags        = Flag.newest.status(:closed).page(params[:page])
      else
        @page[:title] = 'Open Flags'
        @flags        = Flag.newest.status(:open).page(params[:page])
    end
    @flags.each do |flag|
      unless flag.activity.empty? || flag.activity[:status].nil?
        flag.activity[:status].each { |s| s[:by] = Person.find(s[:by]) }
      end
    end
  end

  def show
    @flag = Flag.find_by id: params[:id]
  end

  def update
    if request.put? && @user.moderator?
      flag = Flag.find_by id: params[:id]
      flag.modify mod_params, @user.id
    end

    redirect_back fallback_location: mod_flags_path
  end

  private

  def mod_params
    params.require(:flag).permit(:open, :tags)
  end
end