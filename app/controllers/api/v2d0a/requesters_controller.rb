# noinspection RubyStringKeysInHashInspection
class Api::V2d0a::RequestersController < Api::V2d0a::ApiController
  def index
    if params[:rids] && params[:rids].length > 0
      rids = params[:rids].split ','
    else
      msg = 'Bad Request -- Missing required parameter: rids.'
      err = Api::ApiErrorObject.new(:bad_request, message: msg).call
      return render json: err, status: :bad_request
    end

    success, attrs = field_params
    return render json: attrs, status: :bad_request unless success

    requesters = rids.map { |rid| Requester.find_by(rid: rid) }.select { |r| r }
                     .map { |r| r.as_json.merge({ 'aggregates' => r.aggregates }) }

    status, json = ::RequestersSerializer.new(requesters, collection: true, attrs: attrs).call
    render json: json, status: status
  end

  def show
    requester = Requester.find_by(rid: params[:rid])
    unless requester
      msg = "RequesterId '#{params[:rid]}' does not exist in the database"
      err = Api::ApiErrorObject.new(:not_found, message: msg).call
      return render json: err, status: :not_found
    end

    requester      = requester.as_json.merge({ 'aggregates' => requester.aggregates })
    success, attrs = field_params
    return render json: attrs, status: :bad_request unless success

    status, json = ::RequestersSerializer.new(requester, collection: false, attrs: attrs).call
    render json: json, status: status
  end

  private

  def field_params
    f       = params[:fields] && params.require(:fields).permit(:requesters).to_h
    attrs   = (f && f[:requesters]) ? f[:requesters].split(',') : nil
    success = (params[:fields] && !attrs) ? false : true
    [success, success ? attrs : Api::ApiErrorObject.new(:bad_request, message: 'Specified field type(s) unavailable.').call]
  end
end
