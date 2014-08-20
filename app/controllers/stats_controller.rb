class StatsController < ApplicationController

  before_filter :authorize
  layout nil

  def index
    @reviews = Report.count
    tos_viol_reps = Report.find_all_by_tos_viol(true)
    @tos_flags = tos_viol_reps.count
    @requesters = Requester.count
    @reqs_with_tos_flags = tos_viol_reps.map{|r| r.requester_id}.uniq.count
    @users = Person.count
    reps = Report.all
    @posting_users = reps.map{|r| r.person_id}.uniq.count
  end

end
