module Api
  VERSION = '2.0-alpha'

  class ApiController < ActionController::API
    def error
      header = request.headers['Accept']
      /turkopticon.v(?<version>.+)\+json/ =~ header

      paths  = %w(requesters)
      status = version || !paths.include?(params[:path]) ? :not_found : :unsupported_media_type
      msg    = if status == :not_found
                 version ?
                     "Specified version '#{version}' does not exist." :
                     "Specified path '/#{params[:path]}' does not exist."
               else
                 nil
               end

      render json: Api::ApiErrorObject.new(status, message: msg).call, status: status
    end
  end
end
