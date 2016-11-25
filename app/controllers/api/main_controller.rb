module Api
  class MainController < Api::ApiController
    def index
      render json: {
          meta: { version: Api::VERSION }
          # links: {
          #     requesters: api_default_requesters_url << '?rids={requesterIds}{&fields[]}',
          #     requester: api_default_requesters_url << '/{requesterId}{?fields[]}'
          # }
      }
    end
  end
end