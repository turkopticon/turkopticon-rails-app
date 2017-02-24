class RequestersSerializer
  def initialize(obj, opts = {})
    @allowed_attrs = %w(name rid aggregates aliases)
    @serializable  = obj
    @attrs         = opts[:attrs] || @allowed_attrs
    @collection    = opts[:collection]
  end

  def call
    # illegal_attrs = @attrs - @allowed_attrs
    # msg = "Requested attribute(s) '#{illegal_attrs.join ','}' unavailable."
    # return [:bad_request, Api::ApiErrorObject.new(:bad_request, code: :illegal_attrs, message: msg)] unless illegal_attrs.empty?
    tld = { data: @collection ? [] : nil }
    if @collection
      @serializable.each { |datum| tld[:data] << format_datum(datum) }
    else
      tld[:data] = format_datum @serializable
    end

    [:ok, tld]
  end

  private

  def format_datum(datum)
    obj = { type: :requesters, id: datum['id'], attributes: {} }
    (@attrs & @allowed_attrs).each { |attr| obj[:attributes][attr] = datum[attr] }
    obj
  end
end