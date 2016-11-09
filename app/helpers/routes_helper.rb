module RoutesHelper
  def ujs_path(action, query = {})
    "/ujs/#{action.to_s}" << (query.empty? ? '' : '?' + query.to_query)
  end
end