class ReviewsController < ApplicationController
  before_action -> { require_access_level :verified }

  def index
    @page = { target: params[:user] && Person.select(:email, :display_name).find_by(id: params[:user]) }

    if params[:user]
      @reviews = load_from_query(params.slice :user, :scope).newest.page(params[:page])
    else
      @reviews = Review.newest.valid.page(params[:page])
    end
  end

  def show
    @review = Review.find params[:id]
  end

  def new
    @review = Review.new
    @review.build_hit.build_requester
    %i(rid name).each { |k| @review.hit.requester[k] = params[k] }
    %i(title reward).each { |k| @review.hit[k] = params[k] }
    @review[:rejected]  = 'none'
    @review[:recommend] = @review[:comm] = 'n/a'
  end

  def edit
    @review     = Review.find(params[:id])
    @authorized = @review.person_id == @user.id
  end

  def create
    @review = Review.new form_params.merge(person: @user, ip: request.ip)
    req     = @review.hit.requester
    if @review.save
      Omnilogger.review ltag("CREATE review FOR #{req[:name]} [#{req[:id]}]")
      redirect_to requester_path @review.hit.requester_id
    else
      render 'new'
    end
  end

  # noinspection RailsChecklist01
  def update
    @review = Review.find(params[:id])

    if request.put? && @user.moderator?

      # TODO: move to model

      state = mod_params[:valid_review].to_bool
      issue = state.nil? || @review.flags.status(:open).empty?
      (@review.update_column(:valid_review, state) and @review.requester.touch) unless issue

      Omnilogger.moderator(ltag("UPDATE review##{params[:id]} valid_review:#{state}")) unless issue
      return redirect_back fallback_location: mod_flags_path
    end

    if @review.update(form_params.merge(person: @user, ip: request.ip))
      redirect_to requester_path @review.requester.rid
    else
      render 'edit'
    end
  end

  private

  def form_params
    props = %i(tos tos_context broken broken_context time comm time_pending rejected recommend recommend_context context bonus)
    params.require(:review).permit(*props, hit_attributes: [:title, :reward, requester_attributes: [:name, :rid]])
  end

  def mod_params
    params.require(:review).permit(:valid_review)
  end

  def load_from_query(params)
    permitted = -> (s) { %w(comments flags).include? s }
    if params[:scope] && !(scope = params[:scope].uniq.select &permitted).empty?
      tables = scope.map &:to_sym
      cond   = scope.map { |s| s + '.person_id = :id' }.join ' OR '
      Review.left_outer_joins(tables).where(cond, id: params[:user]).distinct
    else
      Review.by_user(params[:user])
    end
  end

end