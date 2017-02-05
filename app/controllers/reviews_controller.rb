class ReviewsController < ApplicationController
  before_action -> { require_access_level :verified }

  def index
    # TODO: fully integrate queries
    query = params.slice(:user, :comments, :flags)
    @page = { location: query.values.reject { |v| v == 'false' }.length > 0 ? 'Reviews' : 'Recent Reviews',
              rname:    params[:rid] && "for #{Requester.find_by(params[:rid]).rname || params[:rid]}",
              params:   query.to_unsafe_h }

    if query[:user]
      @page[:reviews] = Review.by_user(query[:user]).newest.page(params[:page])
    else
      @page[:reviews] = Review.newest.valid.page(params[:page])
    end

  end

  def new
    @review = Review.new
    @state  = params.slice(:rid, :rname, :title, :reward).permit!.to_json
  end

  def edit
    @review     = Review.find(params[:id])
    @authorized = @review.person_id == @user.id

    rev         = @review.as_json.reject { |k, v| k =~ /(_(?:id|at|.+ew)\z|\Aid)/ || v.nil? }
    hit         = @review.hit.as_json.select { |k| %w(title reward).include? k }
    req         = @review.requester.as_json.select { |k| %w(rname rid).include? k }
    @state      = rev.merge(hit.merge req).to_json
  end

  def create
    review_params            = form_params.reject { |k| %w(rid rname title reward).include? k }
    @review                  = Review.new(review_params)
    @review.dependent_params = form_params.select { |k| %w(rid rname title reward).include? k }.merge user: @user

    if @review.save
      redirect_to requester_path @review.requester.rid
    else
      render 'new'
    end
  end

  # noinspection RailsChecklist01
  def update
    @review = Review.find(params[:id])

    if request.put? && @user.moderator?
      state = mod_params[:valid_review].to_bool
      issue = state.nil? || @review.flags.status(:open).empty?
      (@review.update_column(:valid_review, state) and @review.requester.touch) unless issue
      return redirect_back fallback_location: mod_flags_path
    end

    review_params            = form_params.reject { |k| %w(rid rname title reward).include? k }
    @review.dependent_params = form_params.select { |k| %w(rid rname title reward).include? k }.merge user: @user

    if @review.update(review_params)
      redirect_to requester_path @review.requester.rid
    else
      render 'edit'
    end
  end

  private

  def form_params
    JSON.parse(params.require(:review).permit(:state).to_h[:state])
  end

  def mod_params
    params.require(:review).permit(:valid_review)
  end

end