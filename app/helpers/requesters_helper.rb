module RequestersHelper


  def amt_search(requester)
    build_uri 'searchbar', selectedSearchType: 'hitgroups', requesterId: requester.rid
  end

  def amt_contact(requester)
    build_uri 'contact', requesterId: requester.rid, requesterName: requester.name
  end

  protected

  def build_uri(path, query={})
    amt_base  = 'https://www.mturk.com/mturk/'.freeze
    uri       = URI.join amt_base, path
    uri.query = query.to_query
    uri.to_s
  end
end