class Api::AccountsController < Api::ApiController
  before_action :validate_api_key

  def new
    acct = Person.new person_params
    acct.save validate: false unless Person.exists?(email: params[:email])
    if acct[:id]
      msg = "u##{params[:id]} FROM legacy CREATE account WITH #{params[:email]}"
      Omnilogger.account '%15s (u#%6d) -- %s' % [request.ip, acct[:id], msg]

      data = { id: acct[:id] }
      render json: { status: 200, data: data }, status: :ok
    else
      render json: Api::ApiErrorObject.new(:conflict).call, status: :conflict
    end
  rescue
    render json: Api::ApiErrorObject.new(:bad_request).call, status: :bad_request
  end

  def activate
    user = Person.find_by email: params[:email]
    user.activate! unless user.nil?

    if user
      data = { id: user[:id], email_verified: user[:email_verified] }
      render json: { status: 200, data: data }, status: :ok
    else
      render json: Api::ApiErrorObject.new(:bad_request).call, status: :bad_request
    end
  end

  private

  def person_params
    attrs = %i(email display_name hashed_password salt email_verified)
    throw Exception unless attrs.all? { |v| params.include? v }
    params.slice(*attrs).permit!
  end

  def validate_api_key
    render json: Api::ApiErrorObject.new(:forbidden).call, status: :forbidden unless params[:key] == ENV['LEGACY_API_KEY']
  end
end

