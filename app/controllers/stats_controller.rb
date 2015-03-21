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

  def reviews
    reports = Report.all
    @scores = {}
    attrs = %w{comm pay fair fast}
    attrs.each{|attr| @scores[attr] = {} }
    [1, 2, 3, 4, 5].each{|i| attrs.each{|attr| @scores[attr][i] = 0}}
    reports.each{|r|
      attrs.each{|attr|
        attr_val = eval("r." + attr)
        @scores[attr][attr_val] += 1 unless attr_val.nil? or attr_val == 0
      }
    }
  end

end
