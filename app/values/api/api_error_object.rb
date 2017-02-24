class Api::ApiErrorObject
  CODES  = {
      illegal_attrs: '127'
  }
  ERRORS = {
      bad_request:            { status: '400', title: 'Bad Request' },
      not_found:              { status: '404', title: 'Not Found' },
      unsupported_media_type: { status: '415', title: 'Unsupported Media Type' },
  }.freeze

  def initialize(status, opt = {})
    @status  = status
    @message = opt[:message]
    @code    = opt[:code]
  end

  def call
    err          = ERRORS[@status]
    err[:detail] = @message if @message
    err[:code]   = CODES[@code] if @code
    { errors: [err], status: err[:status].to_i }
  end
end
