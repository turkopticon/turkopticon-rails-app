class ApiConstraints
  def initialize(opts = {})
    @version = opts[:version]
    @default = opts[:default]
  end

  def matches?(request)
    header = request.headers['Accept']
    accept = Mime::Type.parse(header)[0].as_json['string']
    pre    = 'application/vnd.turkopticon'
    if accept.include? pre
      accept == "#{pre}.v#{@version}+json" || accept == "#{pre}+json" && @default
    else
      %w(json */*).any? { |s| header.include? s } ? @default : false
    end
  end
end